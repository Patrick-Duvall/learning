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

If you want to sneak a binding or two through a Scope Gate, you can replace the Scope Gate with a method call: you capture the current bindings in a closure and pass the closure to the method. You can replace class with Class.new( ), module with Module.new, and def with Module#define_method( )

Speculation: we don't think about scopes much in ruby because ivars are accessed directly or as methods and not obstructed by the scope gate

Also, arguments are a one way street to pass variables through a scope gate

#### 3.4 Instace Eval
```ruby
class MyClass
  def initialize
    @var = 1
  end
end
obj = MyClass.new obj.instance_eval do
  self # => #<MyClass:0x3340dc @v=1>
  @var # => 1
end
```

With instance_eval, the block is evaluated with the receiver as self, so it can access the receiver’s private methods and instance variables

Both `#instance_eval` and `#send` allow you to pass normal visibility rules but iinstance_eval has access to ivar's and changes the receiver to self.

`#instance_exec` same as eval ^^^ but can pass arguments to the block.

Instance eval is a context probe. Breaks encapsulation, but can be useful in testing

Clean Room: Object created to evaluate blocks inside of.
```ruby
class CleanRoom; end
clean_room = CleanRoom.new
clean_room.instance_eval do
   # This block is evaluated in the context of clean_room
end
```

### 3.5 callable objects

#### Procs
Most things in ruby are objects, blocks are not
A Proc is a block turned into an object

A block is like an additional, anonymous argument to a method. In most cases, you execute the block right there in the method, using yield. There are two cases where yield is not enough:
• You want to pass the block to another method.
• You want to convert the block to a Proc.
```ruby
def math(a, b); yield(a, b) ;end
def teach_math(a, b, &operation)
  puts "Let's do the math:"
  puts math(a, b, &operation)
end

teach_math(2, 3) {|x, y| x * y}
⇒ Let's do the math: 6
```

#### Procs Vs Lambdas 
- Very similar 2 main differences
(skip to methods per instructions)

#### Callable Objects Wrap-Up
Callable objects are snippets of code that you can evaluate, and they carry their own scope along with them. They can be the following:
• Blocks (they aren’t really “objects,” but they are still “callable”): Evaluated in the scope in which they’re defined.
• Procs: Objects of class Proc. Like blocks, they are evaluated in the scope where they’re defined.
• Lambdas: Also objects of class Proc but subtly different from reg- ular procs. They’re closures like blocks and procs, and as such they’re evaluated in the scope where they’re defined.
• Methods: Bound to an object, they are evaluated in that object’s scope. They can also be unbound from their scope and rebound to the scope of another object.

### 3.6 Writing a domain specific language

```ruby
def event(name)
  puts "ALERT: #{name}" if yield
end

event "monthly sales are suspiciously high" do
  monthly_sales > target_sales
end

event "monthly sales are abysmally low" do
  monthly_sales < target_sales
end
# Calls event method with a name and a block to evaluate if ALERT should be printed
```

## Chapter 4, class definitions
In Java and C#, defining a class is like making a deal between you and the compiler. You say, “Here’s how my objects are supposed to behave,” 



In Ruby, when you use the class key- word, you aren’t dictating how objects will behave in the future, you're running code now.

### 4.1 Class definitions

#### Inside Class definitions
Class definitions return last evaluated statement like a method
Inside a class the class takes on the role of self

#### The Current class

`class` keyword has a limitation: needs name of class to open.
Enter `class_eval/module_eval`

```ruby
def add_method_to(a_class)
  a_class.class_eval do
  def m; 'Hello!'; end end
end

add_method_to String
"abc".m # => "Hello!"
```

instance_eval() only changes self, while class_eval() changes both self and the current class(Sort of but safe to think of this way)

In this way, class_eval effectively opens the class, similar to the `class` keyword.

You can use `class_eval` on any variable that references the class, while class requires a constant.

```ruby
klass = String
klass.class_eval do
  def hello
    "Hello, I am a #{self}"
  end
end
```

class opens a new scope, losing sight of the current bindings, while `class_eval` has a Flat Scope, allowing you to reference variables in the outer scope.

#### Class Wrap up
-  In a class definition, the current object self is the class being defined.
- The Ruby interpreter always keeps a reference to the current class/module. All methods defined with def become instance methods of the current class.
- In a class definition, the current class is the same as self—the class being defined.
- If you have a reference to the class, you can open the class with `class_eval` or `module_eval`

#### Class Instance Variables

