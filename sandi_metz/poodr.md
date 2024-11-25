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
