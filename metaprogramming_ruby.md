# Intro

Code that manipulates itself at runtime

Active record reads DB schema at runtime,defines getter/setter methods programatically

# Object model

calling class a second time reopens existing class and defines things there
need to be careful not to re-define existing method

1.3 truth about classes

objects store instance varialbes, classes store instance methods and class methods

a class is just a souped-up module with three additional methods— new(), allocate(), and superclass()—that allow you to create objects or arrange classes into hierarchies. Apart from these differences, classes and modules are essentially the same.

A module such as Rake, which only exists to be a container of constants, is called a Namespace.

What’s an object? It’s just a bunch of instance variables, plus a link to a class.

1.5 method lookup

When you include a module in a class , Ruby creates an anonymous class that wraps the module and inserts the anonymous class in the chain, just above the including class itself:

Private methods are governed by a single simple rule: you cannot call a private method with an explicit receiver

1.7 summary

• An object is composed of a bunch of instance variables and a link to a class.

• The methods of an object live in the object’s class (from the point of view of the class, they’re called instance methods).

• The class itself is just an object of class Class. The name of the class is just a constant.

• Class is a subclass of Module. A module is basically a package of methods. In addition to that, a class can also be instantiated (with new( )) or arranged in a hierarchy (through its superclass( )).

• Constants are arranged in a tree similar to a file system, where the names of modules and classes play the part of directories and regular constants play the part of files.

• Each class has an ancestors chain, beginning with the class itself and going up to BasicObject.

• When you call a method, Ruby goes right into the class of the receiver and then up the ancestors chain, until it either finds the method or reaches the end of the chain.

• Every time a class includes a module, the module is inserted in the ancestors chain right above the class itself.

• When you call a method, the receiver takes the role of self.

• When you’re defining a module (or a class), the module takes the role of self.

• Instance variables are always assumed to be instance variables of self.

• Any method called without an explicit receiver is assumed to be a method of self.

# Dynamic methods
with send( ), the name of the method that you want to call becomes just a regular argument. (dynamic dispatch)

## Defining methods dynamically
You can define a method on the spot with Module#define_method( ). You just need to provide a method name and a block, which becomes the method body:

## 2.3 method missing
In ruby, no compiler to enforce method calls, so you can call a method that doesnt exist.
if you do, after the lookup, object.send(:method_missing, :missing_method_name) happens
^^ raises an error in kernal.

A message that’s processed by method_missing() looks like a regular call from the caller’s side but has no corresponding method on the receiver’s side

## Dynamic proxies
flickr uses method missing to convert non-existent method  calls to methods and arguments which it forwards to flickr

object that catches method missing and forwards them is a dynamic proxy

ghost methods do not show up in `respond_to?`

const_missing does  the same thing as method missing for const's

since unknown calls become calls to method_missing( ), your object might accept a call that’s just plain wrong, which can be hard to fgiure out. 

Can run into an issue if something higher on inheritance tree defines method, never hit method missing

Blank slate classes do not have inherited methods

## summary
in dynamic languages, you can look for duplication among your methods

Dynamic methods (defining methods with define_method()) and dynamic dispatch (at runtime using send or public_send to send a specific message to an object)

Dynamic proxy catches method missing and forwards it

## Chapter 3 Blocks
- Blocks powerful tool controlling scope

## 3.1 Overview
```
def
  a_method(a, b) a + yield(a, b)
end

a_method(1,2){|x,y|(x+y)*3} #=>10
```
in ruby all methods can implicitly accept blocks
yield evals code in block, blocks return last line evaluated

## 3.2 exercise
Code that runs consists of the code itself and variable bindings.

## 3.3 Closures
Blocks include code and a set of bindings

```
def my_method
  greeting = "Goodbye"
  yield("cruel" ) ## Here yield provides the argument for the block
end

greeting = "Hello"
my_method {|yielded| "#{greeting}, #{yielded} world" } # => "Hello, cruel world"
```

A block is a closure, it captures the local bindings and carries them along with it
A block captures the bindings that are around when you first define the block
### Scope

Unlike java/ C# ruby scopes cannot look out to higher scopes

#### Scope gates
Three places where a program leaves the scope and opens a new one
- Class definitions
- Module definitions
- method definitions

$var_name global variable => accessible anywhere (use sparingly or never)
consider setting ivars on main object instead

#### Flattening the scope gate

The more you become proficient in Ruby, the more you get into difficult situations where you want to pass bindings through a Scope Gate 