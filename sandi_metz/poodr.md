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
