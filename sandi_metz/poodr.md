# Practical Object Oriented Design

## CH1 Object Oriented Design

### 1.1 in Praise of Design
If pain was most cost effective we would be obligated to suffer (it isnt, we arent)

#### 1.1 Problem Design solves
If a program written once, does not need to change, design is irrelevent.

Changes introduce friction , they make design matter

#### 1.1.2 Why Change is hard
Objects are connected by the messages that pass between them.
OOP design is about managing dependencies so that objects can tolerate change

In a small application poor design is tolerable, but successful poorly deisgned apps become larger

#### 1.1.3 Practical Definition of Design
Cost of change eventually eclipses cost of develpoment

We design not in anticipation of a given change, but so that our objects are flexible and can tolerate change

### 1.2 Tools of Design

#### 1.2.1 Design Principals
SOLID Design principals
SRP a class has a single responsibility
Open/closed: Open for extension, closed for modification. You can add new functionality without changing existing code
Liskov Subtypes should be suitable replacements for base type
Interface Segregation: Classes should not have to implement methods they do not use
Dependency Inversion: Depend on abstractions, a high level module needs a calss that responds to `#read` not a specific `FileReader` class

Study by NASA ^^^ Are measurable truths that improve code quality

#### 1.2.2 Design Patterns
Outside scope of book

Check out GOF Design Patterns and Head First Design Patterns

### 1.3 The Act of design

Design Patterns and princiapls are like tools, different programmers will use them to craft a solid chair or a rickety stool

#### 1.3.1 How Design fails
Lack of it, ruby is very gentle/permissive

Overdesign: beautiful castles of code that hem you in

Design seperated from programming, design is a progressive discovery based on a feedback loop of programming.

#### 1.3.2 When to Design

Avoid BUFD, because design is a discovery process, BUFD will often deliver the wrong thing. OOD is about arranging code so it may change easily when needed

#### 1.3.3 Judging design

SLOC (old BOO)

Poorly designed applications can rack up impressive design scores (flog), truth is often at intersection of metrics and intuition

Ultimate metric would be "cost per feature over time interval that matters"

When design prevents software from being delivered on time or at all, you have lost

Break even point differs, a novice may never reap benefit of their design an expert later the same day

### 1.4 A Brief Intro to OOP

#### 1.4.1 Procedural languages
Two things: data and behavior
data is packaged into variables and transformed through behavior

#### 1.4.2 Object Oriented Languages
Data and behavior combined into an Object
objects invoke one another's behavior by sending messages

## CH2 Designing classes with a single responsbility
Foundation is message, most visible is class

Must work now, be eassy to change forever

### 2.1  what belongs in a class?

#### 2.1.1 grouping methods into classes

Classes define a virtual world that constrains imagination
Impossible to make right decsion at outset, newver know less than you know now.
Design is about preserving changeability

#### 2.1.2

define easy to change:
- No unexpected side effects
- Small changes in requirements > Small changes in code
- code is reusable
- changes are made by adding code that is easy to change

This becomes TRUE
*T*ransparent: Consequences of change are obvious in code that is changing, and distant code that relies on it.
*R*easonable: Cost of a change is proportional to the benefits conveyed by the change
*U*sable Existing code is reusable in new and unexpected contexts
*E*xemplary. Code should encourage those who change it to perpetuate these qualities

### 2.2 Creating SRP classes
a class should do the smallest thing useful

#### 2.2.1
Nouns as objects in domain represent simpleist candidates for classes 

Present an implementation of a `Gear` that calculates `gear_inches`(bike value)
`def initialize(chainring, cog,rim,tire)`
May be sufficient for simple app, has some obvious problems(why does a gear have a rim and a tire?)

#### 2.2.2 Why SRP matters

Reusable classes are pluggable units of known behavior that few entanglements.
Multiple responsiblities engenders difficulty of reuse, as responsibilites become entangled within class.

#### 2.2.3 Determining if class meets SRP

Rephrase methods as questions i.e. 'Gear, what is your ratio'(reaonable). 'Gear, what is your tire'(unreasonable).

Attempt to describe it in one sentence. If that sentence uses 'Or' it probably has 2, if it uses 'and' it has 2 and the probably aren't related.

Cohesion: every thing a class does relates to its purpose

#### 2.2.4 Determining when to make decisions

When faced with an imperfect design that 'works' ask yourself 'what is the cost of doing nothing today'

With non-exemplary code, there is a chance someone will reuse it's pattern while you wait for better information.

### 2.3 Writing code that embraces change

#### 2.3.1 depend on behavior, not data

Alwats wrap ivars in accessor methods, this means the method is the only place that understands what the underlying behavior does

Hide data structures

`@data = [[1,3], [2,4], [3,5]]` (rim and tire sizes as 2d array)
An implementation like this *knows* too much about the 2d array, it knows rims are at index 0 and tires are at index 1. When you have data in an array, soon you have behavior all over referencing the arrays structure.

```ruby
class RevealingReference
  attr_reader :wheels
  def initialize(data)
    @wheels = wheelify_data(data)
  end

  def diameters
    wheels.collect { |wheel| wheel.rim + (wheel.tire * 2)}
  end

  Wheel = struct.new(:rim, :tire)
  def wheelify_data # All knowledge of data ctructure is consolidated here
    data.collect{ |cell| Wheel.new(cell[0], cell[1])}
  end
end
```

If you need a messy structure, hide the mess from yourself.

#### 2.3.2 use SRP

Seperating interation from the action of each iteration is a common case of breaking down multiple responsibilities

```ruby
# previous diameters

def diameters
    wheels.collect { |wheel| diameter(wheel) }
  end

def diameter(wheel)
  wheel.rim + (wheel.tire * 2)
end
```

Similar issue in `gear_inches

```ruby 
def gear_inches
  ratio * (rim +(tire * 2))
end

### BECOMES

def gear_inches
  ratio * diameter
end

def diameter
  rim + (tire * 2)
end
```
Once isolated it becomes clear diameter contains only things in wheel. This suggests it should be *in* wheel.

Do these refactors even when you dont know ultimate design.

Impact of single refactor is small, but cumulative effect is huge

- Expose previously hidden qualities
- Avoid need for comments
- Encourage reuse
- Are easy to move.

You could add the `def` diameter` to the wheel struct if you didnt want to make a new wheel now.

Hold off on making decisions until you have to. If wheel can be a struct in Gear, thats ok *until* it needs to be its own thing.

## Chapter 3 Managing dependencies

### 3.11 Recognizing dependenices

An obect has a dependency when it knows

- The name of another class
- The name of a message it expects to send to something other than self
- The arguments an external message require
- The order those arguments go in.

### 3.13 Other dependencies

Depending on an external object which in turn depends on *another* external object is an especially bad case because *any* change ot an inetrmediate object can cause the chain to break, Law of demeter, limit this chain to one external dependency.

## 3.2 Writing loosely coupled code

### 3.2.1 Inject dependencies

WWhen we hard code a reference to another class, we are stating we are only willing to deal with that class , making the including class more concrete. Most of the time it is not the *class* that is important, but the method it responds to. 

```ruby
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  def gear_inches
    ratio * wheel.diameter
  end
end

puts Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches
```
still question of 'where do we put name dependency'

### 3.22 Isolate Dependencies

Sometimes we are constrained such that we cannot inject dependencies. In this case, isolate them

```ruby
class Gear
  ... same code

  def gear_inches
    ratio * wheel.diameter
  end

  def wheel
    @wheel ||= Wheel.new(rim, tire)
  end
end
```

This has a few benefits, first highlights/exposes Gear's Dependency on Wheel, second, reduces the number of places a change to wheel could affect Gear. If for example, Wheel adds a 3rd argument, It could be added *only* in `Gear#wheel`, vs everywhere a Wheel was instantiated.

### 3.3 Isolate vulnerable external messages

```ruby
def gear_inches
  ### scary math
    foo = intermediate result * diameter
  ### more math
end
def diameter
  wheel.diameter
end

# OR 

delegate :diameter, to: :wheel
```

gear_inches now no longer knows that Wheel responds to diameter. Instead, it sends the diameter method to self. If wheel changes the name or signature of its implementation of diameter, the changes on Gear are confined to the simple wrapping method.

### 3.2.3 Remove argument order dependencies

Use Kwargs. It's quite common to tinker with initialization arguments. If positional arguments are used, each change causes you to  change every place the class is initialized, and can lead you to be unwilling to make changes.

How kwargs support Open/Closed Pricipal:
Open for Extension: You can add new keyword arguments to a method without changing the method's existing interface. This allows you to extend the functionality of the method by accepting additional parameters.

Closed for Modification: Existing code that calls the method does not need to be modified when new keyword arguments are added. The method can handle the new arguments internally, providing default values if necessary.

#### Isolate multiparemeter Initialization

Sometimes you dont controle signatures of methods. when you don't i.e. if using a gem or client external to your application, wrap the external class, i.e.

```ruby
module SomeFramework
  class Gear
    attr_reader :chainring, :wheel, :cog
    def initialize
      @chainring = chainring
      @wheel = wheel
      @cog = cog
    end
  end
end

module GearWrapper
  def self.gear(chainring:, wheel:, cog:)
    SomeFramework::Gear.new(chainring, cog, wheel)
  end
end
```

Type of factory

### 3.3 managing dependency direction

#### 3.3.2 Choosing Dependency direction

- Some classes are more likely to have changes in requirements
- Concrete Classes are more likely to change than abstract classes
- Changing a class with many dependents reuslts in widespread change.

Ruby classes and framework, less likely to change than your code

When gear is changed from depending on a class called wheel to being injected with a class that responds to the method :diameter it became more abstract.
This is a type of interface, in ruby, its really east to do this
In say Java youd have to define an interface, define diameter as part of the interface, include hte interface in Whell, and tell gear the injected class is a kind of that interface.

Abstractions represent common, stable qualities
Abstractions are more stable than concretions, but also harder to grok.

| Column 1 | Less Likely to change | More likely to change |
|----------|----------|----------|
| Many dependents | Abstractions gather here | Danger |
| Few Dependents | safe |  safe, many changes, few consequences |

Heuristic: Depend on things that change less often than you do.


## Chapter 4 Creating flexible interfaces

## 4.1 understanding interfaces

In an application where objects can send any message to any other message, the objects become like an interwoven matt, because objects reveal too much

### 4.2 defining interfaces

*Public interfaces*
- Reveal primary responsibility
- Are expected to be invoked by others
- Do no change on whim
- Are thoroughly documented in tests

*Private Interfaces*
- Handle implementation details
- are unsafe for others to depend on
- may not be references in tests

### 4.3 Finding public interface

Domain objects Present themselves as the first 'thing' to build. They are obvious, because they stand for big real world things.

Sequence Diagrams are a low cost way to experiment with objects and messages.
Sequence Diagrams explicitly specify messages that should pass between objects using their public interfaces.

They invert design conversation to "what object should respond to what message".

### 4.3.4 Ask for what instead of telling how

An implementation of a Trip and Mechanic class where Trip tells Mechanic every step needed to prepare a bicycle is problematic. I.e. "clean bicycle, pump tires, lube chain, etc" Requires Trip to know what Mechanic does. If mechanic adds a new responsibility, Trip will have to be changed in it's algorithm of telling Mechanic *what* to do.

Change it so Trip tells Mechanic `prepare_bicycle` and the mechanic `prepare_bicycle` method takes all the steps needed to prepare a bike.

### 4.3.5 Seek context independence

Things that a class knows about other objects make up its context. Trip expects to hold a mechanic object that response to `prepare_bicycle`

Can't reuse trip without a mechanic-like object

Dependency injection allows objects to collaborate with others without knowing who they are.

At first it seems impossible, Trips need bikes prepared, so a trip needs to ask a mechanic to prepare bikes.

```mermaid
sequenceDiagram
    participant Trip
    participant Mechanic
    Trip->>Mechanic: prepare_trip(self)
    Mechanic->>Trip: bicycles
    Trip-->>Mechanic: 
    Mechanic->>Mechanic: prepare_bicycles
    Mechanic-->>Trip: 
```
Here, Trip knows it want to be prepared, passes itself to mechanic, mechanic calls back to trip to get bicycles, and prepares them

Here, trip doesnt know or care that is has a mechanic, it merely holds onto an instance which will recieve `prepare_trip` and trusts it to do its job.

### 4.3.6 Trust other objects

If objects were human ' I know what I want, and I trust you to do your part'

### 4.3.7 using Messages to Discover Objects

A customer, in order to choose a trip, would like to a see a list of trips of appropriate difficulty, wiith rental bikes available.

It is perfectly reasonable `Customer` would sent `suitable_trips` it is not reasonable Trip would recieve it ... but what would.. a `TripFinder

```mermaid
sequenceDiagram
    participant Customer
    participant TripFinder
    participant Trip
    participant Bicycle

    Customer->>TripFinder: find_trips(difficulty, on date, need_bike)
    TripFinder->>Trip: get_trips(on_date,difficulty)
    Trip-->>TripFinder: list of trips
    loop for each trip
        TripFinder->>Bicycle: suitable_bicycle(on_date, route_type)
        Bicycle-->>TripFinder: 
    end
    TripFinder->>Customer: 
```

Sequence Diagrams make convoluted discussions easy and low cost to change.

### 4.4 Writing code that puts its best interface forward.

It is your interfaces, more than anything, that define your application

### 4.4.1 Create explicit interfaces

goal: Write code that works today and can be easily reused.

Methods in public interface should 
- Be Explicitly identified
- Be More about what than how
- Prefer KWARGS.

Do not test private methods, or segregate the tests.

### 4.4.2 Honor Public Interfaces

If your design forces you to reuse the private interface of anohter class, *first* rethink design.

### 4.4.4 

Construct Public interfaces with an eye toward minimizing context they require.

This could be a new wrapper class, a new method on the oublic interface of a class, or a wrapping method to isolate the dependency in the calling class.

### 4.5 Law of Demeter.

Set of coding rules resulting in loosely coupled objects. (one dot rule)

Below Trip#depart methods

- customer.bicycle.wheel.tire
- customer.bicycle.wheel.rotate
- hash.keys.sort.join(',')

Remember TRUE, transparent, reasonable, usable, exemplary

Above code is not reasonable, if wheel changes, Trip may have to change.

Changing rotate or tire may break something in trip, something far away breaks Trip, not Transparent.

Trip Needs a customer with a bike with a wheel, lots of context, not reusable.

1 is much less worse than 2, query message vs command, in your use case, may be chaper to reach through intermediate objects to grad an attribute. NEVER do this with behavior.

3 is not problematic, it's all the same thing, an Enumerable of Strings.

### 4.5.3 avoiding Demeter violations.

Delegation lets an object intercept a message sent to self and send it elsewhere. 

### 4.5.4 Listen to Demeter

Message chains occur when design is influenced by objects you already know.

Reaching across means "Theres some code I know I want and I know how to get it" Makes your code not only know what it wants, but how to navigate across a bunch of other classes to grab it, drastically increasing your classes knowledge of other objects and coupling it to the current object structure.

Demeter violations are clues that there are objects whose public interface is lacking.

### 4.6

Obecjt oriented applications are defined the messages that pass between them using their public interfaces.

## CH 5 Reducing cost with Duck Typing.

### 5.1 understanding duck types

Class is just one way for object to gain public interface

### 5.1.1 overlooking duck type

At a high level we go from a `Trip` class looking to be prepared. We start with a trip class with a case statement switching on `preparer`'s type. The problem with this implementation Is `Trip` needs to know what preparers are AND how they do it. IT has external dependecies on class names and method names of those classes.

```ruby
class Trip
  attr_reader :bicycles, :customers, :vehicles

  def prepare(preparers)
    preparers.each do |preparer|
      case preparer
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up(vehicle)
        preparer.fill_water_tank(vehicle)
    end
  end
end
```

At a high level, Trip's prepare method wants to prepare a trip. The method Trip can send each preparer is `prepare_trip(self)` Objects that implement `prepare_trip` are `Preparers` and objects that interact with preparers need to trust them to implement the `prepare_trip` interface.

NEW DESIGN

```ruby
class Trip
  def prepare(preparers)
    preparers.each{ |preparer| preparer.prepare_trip(self) }
  end
end

class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each { |bike| prepare_bicycle(bicycle)}
  end
end

class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
end

# etc. for Driver
```

Initial example depended on concrete class, making it easy to understand, but dependency laden.

Concrete code is easy to understand but costly to change. Abstract code is harder to understand but more flexible. Fundamental tension of OOP.

Polymorphism: Ability of many different objects to respond to the same message. A single message thus has many forms.
Duck typing is one way, inheritance and behavior sharing with modules are another.

### 5.2 Writing code that relies on ducks

### 5.2.1 recognizing hidden ducks

- Case statements that switch on class
- kind_of? and is_a? checks
- responds_to?
- observation `try` is often a hidden switch
- `&.` is a hidden switch on nil

These all indicate you are missing an object with an undiscovered public interface. I doesnt matter that the undiscovered interface is a duck, its the interface that matters, not the class of the object that implements it.

See CH 9 for testing ducks.

### 5.2.5 choose ducks wisely

An example from Rails framework, with type swtiching on nil and array. These core language methods and classes are very stable and unlikely to change, so the check on type here is relatively safe.

### 5.3 conquering fear of duck typing

AFAICT static type checking is the exact opposite of duck typing

Metaprogramming often requires ducktyping as there are many cases when you cannot know what a class will be at runtime.

### 5.4 summary

Messages are at the center of OO applications

Duck types detach these public interfaces from classes. Duck typing reveals underlying abstractions that might be invisible 

Thinking ahead to testing, doing something like writing an Rspec expectation 'is a preparer' asserting members of a duck type respond to a certain interface and including it in the spec files of classes that are also ducks.

## Chapter 6, Inheritance

### 6.1 Classical inheritance

Classical => based on classes, 
Inheritance form of automatic message delegation up the class ancestor chain

### 6.2 When to use inheritance

When a pre-existing class contains most of the behavior you need, its tempting to add a a type swtich. Generally this is a bad idea(caveat *may* be expedient )

This is the behavior inheritance solves: That of highly related types that share common behavior but differ on a dimension.

Nil and String both subclass Object, nil implements `#nil?` as true, while object impements it as `false`. String delegates nil? up to object, while nil does not because the interface is defined.

Subclasses are their superclass AND MORE.

### 6.3 Misapplying inheritance.

### 6.4 Finding the Abstraction.

Subclasses are *specializations* of their superclasses. They should be everything they are PLUS MORE
Inheritance should be used for generalization => specialization relationships.

### 6.4.1 Creatign an abstract super class.

Trying to get a class diagram where both RoadBike and MountainBike subclass Bike.

Abstract: Disassociated from any specific instance.

It might not be right to commit to inheritance with with  2 classes. Might be right to duplicate code. Depends on how much change you anticipate, and how soon you anticiapte a third use case.

Easier to promote code to super class then demote.

When deciding on Refactoring ask the question: What happens if Im wrong.

Failure to promote is obvious, when another sublass needs the behavior, it will be seen. 
*BUT* Failure to demote is worse, creates behavior that is not applicable to all subclasses and subclasses are no longer specializations of their more general superclass.

### 6.4.4 Template method pattern.
Defining a basic structure in the superclass and sending messages to acquire subclass specific contributions is known as template method pattern.

The Initialize here is the template method, Bicycle relys on subclasses to provide reasonable defaults

```ruby
class Bicycle
  attr_reader :size, :chain, :tire_size

  def initialize(**opts)
    @size = opts[:size]
    @chain = opts [:chain] || default chain
    @tire_size = opts[:tire_size] || default_tire_size
  end

  def default_chain ; '10-speed' ; end
end

class RoadBike < Bicycle
  def default_tire_size ; '23' ; end
end

class MoutainBike < Bicycle
  def default_tire_size ; '2.1' ; end
end
```

### 6.4.5 Implementing every template method

Above, Bicycle's `initialize` sends `default_tire_size` but does not implement it. Bicycle imposes a requirement on it's subclasses but does not make it explicit. MAke is explicit

```ruby
class Bicycle
  def default_tire_size
    raise NotImplementedError, "#{self.class} should have implemented"
```

### 6.5 Managing coupling between subclasses and super classes

Having subclasses call super creates a dependency and requires subclasses to know the algorithm. IF the algorithm changes, subclasses may break.

### Decoupling Subclasses useing Hook Methods

```ruby
class Bicycle
  def initialize(**opts)
    @size = opts[:size]
    @chain = opts [:chain] || default chain
    @tire_size = opts[:tire_size] || default_tire_size

    post_initialize(opts)
  end
end

class RoadBike
  def post_intialize(opts)
    @tape_color = opts[:tape_color] # road bike can provide specializationd and overrides
  end
end
```

Road bike no longer knows the algorithm and is more flexible in face of uncertain future.

We can do the same thing with spares.

THIS
```ruby
class Bicycle
  def spares
    {tire_size:, chain:}
  end
end

class RoadBike
  def spares
    super.merge(tape_color:)
  end
end
```

BECOMES THIS
```ruby
class Bicycle
  def spares
    {tire_size:, chain:}.merge(local_spares)
  end

  def local_spares ; {} ; end # Hook for subclasses override
end

class RoadBike
  def local_spares
    {tape_color:}
  end
end
```

Upside of this coding pattern, making another type is blindingly easy, just supply the specializations.
### 6.6 Summary

 Inheritance solves the problem of related types that share a great deal of common behabior but differ alogn a dimension. Allows you to isolate shared code and implement common algorithms in an abstract class , while providing a sturcture that lets subclasses specialize. The best way to create an abstraction is by pushing code up from a concrete subclass.

## CH 7

Inheritance is bad at combining behavior of two existing subclasses

### 7.1 Understanding Roles

Sometimes you need to share behavior orthagonal to the role of a class (I.e. active record)

### 7.1.1 Finding roles

Modules allow objects of different classes to play a common role using shared code.

when an object includes a module, the methods become included via automatic method delegation, This looks the same from the including class' standpoint: message received, not understood, routed, value returned

Objects respond to messages

-They implement
- Objects above it in the heirarchy implement
- Those implemented by included modules
- Thoes implemented by modules included in parent classes

### 7.1.2 organizing responsibilities

Implementation where a schedule knows too much (what target object it recieves in order to schedule it )

```mermaid
sequenceDiagram
    participant Instigating Object
    participant Schedule

    Instigating Object->>Schedule: schedulable?(target, starting, ending)[Target = Bicycle]
    Schedule->>Schedule: lead_days => 1
    Instigating Object->>Schedule: schedulable?(target, starting, ending)[Target = Mechanic]
    Schedule->>Schedule: lead_days => 4
    Instigating Object->>Schedule: schedulable?(target, starting, ending)[Target = Vehicle]
    Schedule->>Schedule: lead_days => 3
    Schedule->>Instigating Object: !scheduled?(target, starting, lead_days, ending)
```
Here, schedule checks class to know what value to use. Knowledge doesnt belong in schedule, belongs in class whose name Schedule is checking.

### 7.1.3 

the fact schedule checks many class names to deterimine what value to use for a variable suggests the varaible should be a message to those classes.

Here Schedule does not care about Target's class, but just expects it to respond to message `lead_days`

```mermaid
sequenceDiagram
    participant Instigating Object
    participant Schedule
    participant Target

    Instigating Object->>Schedule: schedulable?(target, starting, ending)[Target = Bicycle]
    Schedule->>Target: lead_days
    Target-->>Schedule: 
    Schedule->>Instigating Object: !scheduled?(target, starting, lead_days, ending)
```

StringUtils#empty(string) is silly: In OOP why woould an instigator ask StringUtils if a string is empty instead of just asking the string `string#empty`

the above Is similar. The instigator wants to know if an object is scheduleable, but is asking the Schedule rather than the object.

### 7.1.4 Writing the concrete code

Start by picking a concrete class an implementing the `schedulable?` method, then refactor for *all* schedulables.

```mermaid
sequenceDiagram
    participant Instigating Object
    participant Bicycle
    participant Schedule
    

    Instigating Object->>Bicycle: schedulable?(target, starting, ending)
    Bicycle->>Bicycle: lead_days
    Bicycle->>Schedule: !scheduled(self, starting - lead days, ending)
    Schedule-->>Bicycle: 
    Bicycle-->>Instigating Object: 
```

```ruby
class Bicycle

  def initialize(**opts)
    @schedule = opts[:schedule] || Schedule.new # Inject schedule w/default
  end

  def schedulable?(starting, ending)
    !scheduled(starting - lead_days, ending)
  end

  def scheduled?(starting, ending)
    schedule.scheduled?(self, starting, ending)
  end

  def lead_days
    2
  end

  #...
```

Objects using bicycle no longer need schedule

### 7.1.5 Extract the abstraction

Mechanic and vehicle both need this role.

```ruby
module Scedulable

  def schedule
    @schedule ||= Schedule.new
  end

  def schedulable?(starting, ending)
    !scheduled(starting - lead_days, ending)
  end

  def scheduled?(starting, ending)
    schedule.scheduled?(self, starting, ending)
  end

  # includers may override
  def lead_days
    0 
  end
end
```

Dependency on Schedule removed from Bicycle, isolated in Schedulable module. Similar to inheritance where parent classes must implement methods of their child classes, even if to say 'not implemented' or provide a default.

