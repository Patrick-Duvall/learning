# Chapter 4

Perfect does not exist

I'm the only good driver on earth, so i drive defensively.

I also defend against myself

## 23 Design by contract.(DBC)

document rights/responsilities of software modules
Document + verify: heart of DBC

Preconditions: what must be true, callers responsibility pass good datea

Post conditions: garauntees of behavior, "post" => WILL conclude

If all preconditions met by caller, all postconditions and invariants garaunteed by program

Emphasize lazy code. Be strict in what you will accept and promise as little as possible. If contract says accept anything and promise world in return ... you have a lot to write.

DBC more efficient/dryer than defensive programming where everyone has to validate data shape.

Self: 
don't be defensive about things that are actually contract violations. Use DBC-style thinking (assertions, "crash early") for programmer errors and internal invariants — bugs in your code
  should fail loud and fast. Reserve defensive checks for genuine trust boundaries — data crossing from the outside world (user input, external systems) — where you don't control the caller and silent/robust handling is actually appropriate.

  Define boundary conditions huge step in writing better software.

  Have compiler (or spec) check contract for you

  DBC and crashing early

  Whos responsible for checking precondition

  Self: In my mind, the callee, if we have hte caller check, then we need to sprinkle the precondition checks throughout the codebase. In ruby(example), prefer gaurd clauses as early returns in methods instead of at call sites.

  As I read sqrt example, it seems it forces the coercion in hte caller (must be positive int) but the handling in the function. Seems to more SRP (method takes a positive int, returns square root).

  Keep inviolate laws seperate from policies/business logic.
  semantic invariant: Err in favor of consumer.

####  Why not more adopted

the idea won as a philosophy (assert your invariants, crash on programmer error, validate only at real trust boundaries — this is straight DbC thinking) even though the formal mechanism (typed pre/postconditions, invariants,
  Eiffel-style tooling) mostly lost to ad hoc asserts and tests.

#### Fencepost error (off by one)
Count fence posts, or spaces inbetween?

## TODO exercise 14
