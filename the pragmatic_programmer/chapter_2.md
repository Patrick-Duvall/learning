## The Essence of Good design

Value: ETC easiest to change.

### Shared across both paradigms

  **Small units with one reason to change** — functions or objects that do one thing are easy to swap, test, and delete. The `Updater` class you just reviewed is a good example: extracted from the controller so
  each piece changes independently.

  **Explicit dependencies** — take what you need as arguments rather than reaching for globals or hidden state. This is why kwargs beat the context hash: the signature is a contract you can read.

  **No hidden effects** — a unit that only affects its own scope is safe to move. A unit that silently writes to a log, sends a webhook, and updates a DB record in one call is hard to change without breaking
  something else.

  **Pure core, effectful shell** — push I/O (DB writes, HTTP calls, logging) to the edges. The center of your logic becomes trivially testable.

  ---

  ### Functional emphasis

  | Principle | What it means in practice |
  |---|---|
  | **Immutability** | Don't mutate inputs; return new values. A function that modifies its argument creates action-at-a-distance bugs. |
  | **Referential transparency** | Same inputs → same output, always. Makes caching, testing, and reasoning trivial. |
  | **Composition over configuration** | Build complex behavior by chaining small functions rather than parameterizing a large one with flags. |
  | **Data as values** | Represent state as plain data structures rather than objects with identity. Easy to serialize, log, and compare. |
  | **No implicit context** | Everything a function needs is in its arguments. Nothing hidden in `self` or thread-local state. |

  ---

  ### OOP emphasis

  | Principle | What it means in practice |
  |---|---|
  | **Tell, don't ask** | Send a message to an object and let it decide; don't query its state and decide for it. Reduces coupling. |
  | **Depend on abstractions** | Depend on interfaces/duck types, not concrete classes. Lets you swap implementations without touching callers. |
  | **Open/closed** | Open for extension, closed for modification. Add behavior by adding code, not editing existing code (e.g., new `when` branches vs. new subclasses). |
  | **Law of Demeter** | Only talk to your immediate collaborators. `a.b.c.do_thing` means you're coupled to three layers. |
  | **Value objects** | Small, immutable objects that represent a concept (a Money amount, an Address). No identity, no side effects — behave like FP values inside OOP. |

  ---

  ### The one meta-principle both agree on

  **Make illegal states unrepresentable.** Use types, kwargs, required fields, and validation at boundaries so bad data can't exist inside the system at all.


### DRY: 

Every peice of knowledge has a single unambiguous source.

InterDeveloper Duplication => High Coms/review

Meyers Uniform Access Principle: all services offered by a module available through uniform notation, does not betray if implemented through storage or computation.

###Orthogonality: at right angles, independeant , decoupled.

Decoupled code easier to test, more reusable.

## Singleton Pattern: Summary

  **What it is:** A class that allows only one instance, with a global access point to it.

  ---

  ### Three common Ruby forms

  ```ruby
  # 1. stdlib (enforced by the language)
  include Singleton
  MyClass.instance  # always same object; MyClass.new raises

  # 2. Manual class-level memoization (most common in Rails)
  def self.instance
    @instance ||= new
  end
  private_class_method :new

  # 3. Module as singleton (stateless utilities)
  module FeatureFlags
    def self.enabled?(flag) = config[flag]
    def self.config = @config ||= load_flags
  end
  ```

  ---
  When to use it

   |---|---|
  | **Correctness** — multiple instances would be wrong | Connection pools (one pool × 10 threads, not 10 pools) |
  | **Expensive init** — build cost is high, inputs never change | API clients, config loaders, regex compilers |
  | **Coordination** — shared resource needs one authority | Rate limiters, job queues, audit loggers |
  | **Identity** — callers need the *same object*, not equal values | Caches keyed by object identity |

  ---
  When NOT to use it

  - The object holds per-caller state — use regular instantiation
  - You need testability — singletons make mocking painful and bleed state between tests
  - You're tempted because it's "easier than passing the object around" — that's the wrong reason; use dependency injection instead

  ---
  Related patterns

  - Instance-level memoization (@var ||= Thing.new) — same caching idea, scoped to one object's lifetime, much safer
  - Class-level memoization (@@var or self.@var ||=) — process-wide like a singleton, without the enforced single-instance contract
  - Global variables ($redis) — functionally a singleton, just with no encapsulation

  The core question is always: does having two of these break something, or just waste memory?
  If two would be wrong, a singleton is the right call. If two would just be redundant, memoization is enough.

  ## Orthogonality
  - means features compose independently — changing one thing doesn't unexpectedly affect another.

  ---
  Object-Oriented: Lower Orthogonality

  - Coupled state and behavior. Methods mutate object state, spreading side effects implicitly across anything holding a reference.
  - Inheritance entanglement. A subclass change can break parent or sibling behavior non-obviously; overriding one method often implies
  constraints on others.
  - Dual equality model. Identity (same reference) vs. structural equality forces two separate reasoning tracks simultaneously.
  - Design patterns as workarounds. Observer, Decorator, Strategy exist largely to recover orthogonality the paradigm gave up.

  ---
  Functional: Higher Orthogonality

  - Pure functions compose freely. Output depends only on input — no hidden coupling between functions.
  - Immutability eliminates shared-state interference. Transforms produce new values; the original is untouched.
  - Effects are an explicit, separable concern. Systems like Haskell's IO make computation and side effects orthogonal by construction.
  - Higher-order functions are uniformly composable. map, filter, fold work identically across any compatible structure — no special
  cases.

  ---
  Core Tension

  OOP trades orthogonality for modeling intuition — objects mirror real-world entities naturally. FP recovers orthogonality but pushes
  effectful complexity into the type system, making it explicit rather than hidden.

  Modern languages (Scala, Rust, Kotlin, Swift) borrow from both: FP's immutability for data pipelines, OOP's encapsulation for module
  boundaries.


### Reversability

with every decision you commit to a smaller target: A reality with fewer options.

Ceratin actions (vendor DB, architecture) Comes wiht Cost to change

Try and make decisions like sand at beach.

People think of code as flexible, but you also need your architecture, deployment, and vendor integrations to be flexible.
Hide 3rd party API's between own abstraction layer

### Tracer Bullets

Tracer bullet development, immediate feedback under actual conditions with moving goal.

^^ CAN tend to waterfall.

User story of a happy path to show that everything is plumbed. Once on target, adding funcitonlity is easy

Alternative: heavy engineering approach, modules in vacuum, eventual assembly and testability

Question/observation: It seems that our two heavy refactors, BI and identity, are tending toward the engineernig heavy waterfall approach.
- Why? Because there is NO user story at the end. It is small, changes, including dual writes, migrations, then a cutover after everything is on a new system.
Open: Does it have to be this way?

Tracer
- Users get functionality early
