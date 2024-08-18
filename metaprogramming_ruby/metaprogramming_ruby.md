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

Ruby interpreter assumes all ivars belong to current object, as such 
``ruby
class newClass
  @variable # class instance variable not same as below

  def initialize
    @variable #this, instance variable
  end
end
```

#### Bookworm problem
- write spec for to_s, but you dont know the time the book was loaned
```ruby 
class Loan
  def initialize(book)
    @book = book
    @time = Time.now
  end

  def to_s
    "#{@book.upcase} loaned on #{@time}"
  end
end
```

You can also use class variables @@variable instead of class instance variables
But this can be surprising since class varaibles dont belong to classes, they belong to heirarchies. Below @@v is defined in context of main and belongs to Object, which MyClass can then change
```ruby
@@v = 1
class MyClass
  @@v = 2
end
@@v #=>2
```

For this reason prefer class instance varaibles generally

Interesting note: `@time_class || Time` is a form of a guard clause

Book solution to 
```ruby 
class Loan
  def initialize(book)
    @book = book
    @time = Time.now
  end

  def self.time_class
    @timeclass || time
  end

  def to_s
    "#{@book.upcase} loaned on #{@time}"
  end
end

### Spec 

class FakeTime
  def self.now
    'Mon Apr 06 12:15:50'
  end
end

class TestLoan < Test::Unit::TestCase
  def test_conversion_to_string
    Loan.instance_eval { @time_class = FakeTime }
    loan = Loan.new('War and Peace')
    assert_equal 'WAR AND PEACE loaned on Mon Apr 06 12:15:50', loan.to_s
  end
end
```

This uses `@time_class` in the context of the spec with instance eval to have a testable assertion on the time, while not tests will not have this class ivar and use `Time`. But seems problematic to me as generally testing needs should not drive implementation code.

## 4.2 Quiz taboo

### 4.3 singleton methods

Problem:  The Below class has a method `:title?` that is the only functionality different than a string. Class does not do enough to justify existing *but* we want to preserve the `:title?` behavior. No monkye patch, since it doesnt make sense for all strigns to respond to `:title?`
```ruby
class Paragraph
  def initialize(text)
  @text = text
  end

  def title?; @text.upcase == @text; end
end
```

You can add singleton methods to a object by calling `def object.method_name` i.e.
```ruby
paragraph = "any string can be a paragraph"

def paragraph.title?
  self.upcase == self
end
```

this allows us to discard the paragraph class. ( I am currently wondering if this is any better than something like  `def is_title(string)` and just performing a comparison inside there)

In Duck typing as long as objects respond to method calls, we don't care if they are instance methods, singleton methods, or even ghost methods.

#### The truth about class methods
classes are just objects and class names are just constants
```ruby
an_object.a_method
AClass.a_class_method
```

Class methods are just singleton methods of a class.
Below jsut takes advantage of the fact that self is a the class in the context of a class definition.
```ruby
class MyClass
  def self.yet_another_class_method; end
end
```

#### Class Macros

attr_accessor
Ruby objects dont have attributes, attribute behavior is defined through methods of a reader and a writer

attr_* methods are class macros, they look like keywords but are regular class methods meant to be used in a class definition

#### Class Macros Applied
Problem statement: poorly named methods that are called by users of your application you have no control over.

You can rename the methods if you make a class macro to deprecate the old names.
```ruby
def self.deprecate(old_method, new_method) define_method(old_method) do |*args, &block|
  warn "Warning: #{old_method}() is deprecated. Use #{new_method}()."
  send(new_method, *args, &block)
end

deprecate :GetTitle, :title
deprecate :LEND_TO_USER, :lend_to
deprecate :title2, :subtitle

book = Book.new
book.LEND_TO_USER("Bill" )

⇒ Warning: LEND_TO_USER() is deprecated. Use lend_to().
Lending to Bill
```

### 4.4 EigenClasses

UFO's of ruby might never see, but signs are there

#### Mystery Singleton Methods
Ruby finds methods by going Right into reciever class, then Up heirarchy

Where do singleton methods live? `object` is not a class, not on class or all instances of that class would share it
```ruby
def object.my_singleton_method; end
```
#### Eigenclass revealed
When you ask a ruby object for its class, there is a hidden class that `Object#class` does not expose

if you want reference to eigenclass, return self out of scope
An eigen class is where an object's singleton methods live
```ruby
obj = Object.new
eigenclass = class << obj
  self
end

def obj.my_singleton_method; end
eigenclass.instance_methods.grep(/my_/) # => ["my_singleton_method"]
```
### Method Lookup revisited
Helper method to get eigenclass
```ruby
class Object
  def eigenclass
    class << self; self; end
  end
end
```

If an object has an eigenclass, Ruby starts looking for methods in the eigenclass rather than the conventional class, and that’s why you can call Singleton Methods such as obj#a_singleton_method(). If Ruby can’t find the method in the eigenclass, then it goes up the ancestors chain

#### EigenClasses and inheritance
Syntax note: Class denotes a conventional class #Class denotes an eigenclass. S and C in diagram denote class and superclass

An `object`'s true class is it's eigenclass `#object`.
That `#object`'s class is the `class` of `object` `object.eigenclass.class == object.class`

| Classes | Eigenclasses |
|----------|----------|
| Object C->    | #Object     |
| CClass S^ C->   | #CClass S^    |
| DClass S^ C->    | #DClass S^    |


Define a method on CClass
```ruby
class CClass
  def self.class_method; end
end
```

Even if `class_method` is defined on C, you can also call it on D. This is probably what you expect, but it’s only possible because method lookup starts in #D and goes up to #D’s superclass #C, where it finds the method.

#### Great Unified theory
7 rules of the Ruby Object Model

1. There is only one kind of object, be it an object or a module
1. There is only one kind of module, be it a regular module, class, eigenclass, or proxy class.
1. There is only one kind of method and it live in a module, most often in a class.
1. Every object, classes included, has it's own 'real class' be it an eigenclass, or a super class.
1. Every class has exactly one superclass, save `BasicObject` This means there is a single ancestor heirarchy from any object to `BasicObject`
1. The superclass of the eigenclass of an object is the eigenclass of that classes superclass.
1. When you call a method, ruby goes 'right' to the object's real class, then 'up' the ancestor chain

#### Class Attributes

To define a class attribute (similar to instance attr_accessors) Open a class' eigenclass and define the `attr_accessor`s there.

`Object#extend` is simply a shortcut that includes a module in the receiver’s eigenclass

```ruby
module MyModule
  def my_method; 'hello'; end
end

obj = Object.new
obj.extend MyModule
obj.my_method => 'hello'
```

### 4.6 aliases

You can give an alternate name to a Ruby method by using the `alias`
keyword

### Around aliases

```ruby
class String
  #This creates an alias for the original length method. 
  alias :real_length :length 

  def length
    real_length > 5 ? 'long' : 'short'
  end
end
```
In the above example we call write a new method `length` but can still call the old `length` method by calling it's alias `real_length`

1. You alias a method.
2. You redefine it.
3. You call the old method from the new method.

### 4.7 quiz: broken math
Most Ruby operators are actually Mimic Methods (241).” For example, the + operator on integers is syntactic sugar for a method named Fixnum#+( ). When you write 1 + 1, the parser internally converts it to 1.+(1).

## Chapter 5 Code that writes code.

### 5.1 assignment: 

### 5.2
Kernal#eval takes a string of code and evaluates it 
```ruby
array = [10, 20]
element = 30
eval("array << element") # => [10, 20, 30]
```

You can create a Binding with the Kernel#binding method
Binding is a scope packaged as an object

IRB calls  `eval(statements, @binding, file, line)`
irb sets the @binding variable to evaluate your commands in the context of that object, similar to what instance_eval( ) does.

Strings of code have some downsides and you should prefer blocks
1: syntax highlighting
2: Security

example
Create a `array_explorer` that returns the value of any array method, expose it via we bsite/UI

```ruby
def explore_array(method)
  code = "['a', 'b', 'c'].#{method}" puts "Evaluating: #{code}"
  eval code
end

# user feeds string
⇐ object_id; Dir.glob("*")
⇒ ['a', 'b', 'c'].object_id; Dir.glob("*") => [your own private information here]
# above ; causes in line line break, so after the id call it logs all the names/files in the current directory

```

Only strings that derive from an external source can contain malicious code,

#send is similar, but you have to pass the mehod names and arguments seperately
``` ruby
def explore_array(method, *arguments)
  ['a', 'b', 'c'].send(method, *arguments)
end
```


#### Tainted objects
Ruby automatically marks objects that come from external sources as 'tainted'


you can set safe levels in your code that will. Any safety level higher than 0 refuses to eval tainted strings
```ruby
$SAFE = 1
user_input = "User input: #{gets()}" eval user_input
⇐ x=1
⇒ SecurityError: Insecure operation - eval
```

By using safe levels carefully, you can write a controlled environment for `eval`9 Such an environment is called a Sandbox. Let’s take a look at a sandbox taken from a real-life library: ERB

```ruby
#template.rhtml
<p><strong>Wake up!</strong> It's a nice sunny <%= Time.new.strftime("%A") %>.</p>

#
require 'erb'
erb = ERB.new(File.read('template.rhtml'))
erb.run

 <p><strong>Wake up!</strong> It's a nice sunny Friday.</p>

#Inside ERB code vv
class ERB
def result(b=TOPLEVEL_BINDING)
  if @safe_level proc {
    $SAFE = @safe_level
    eval(@src, b, (@filename || '(erb)'), 1) }.call
  else
    eval(@src, b, (@filename || '(erb)'), 1)
  end
end
```

In this code, the `@src` is the code inside the <% %> block. If a safe level is provided, the @src is evaluated in the context of a clean room, else, it is simply evaluated.

### 5.7 Hook methods

`inherited` and `included` are instance method of Class, and Ruby calls them when a class is inherited.
By defualt do nothing, but can override

can be used to define class methods on the including  class
Normally including adds instance methods, and extending adds class methods, this pattern can be used to have both in a single module

``` ruby
module MyMixin
  def self.included(base)
    base.extend(ClassMethods)
  end

  def instance_method
    'instance_method()'
  end

  module ClassMethods
    def class_method
      "class_method()"
    end
  end
end
```

## CH 6 Epilogue

Metagprogramming is just programming

# Metaprogramming in Rails

## CH 7 Design of ActiveRecord

### 7.1 preparing tour
ActiveRecord - M in mvc
ActionPack - VC in mvc
ActiveSupport - utilities(logging, time, etc)

### 7.2 Design of ActiveRecord
Object Relational Mapper, maps DB records to ruby objects

Simplified version of how Active record uses ghost methods to define methods from DB schema

```ruby
class ActiveRecord::Base
  def method_missing(name, *args)
    if name.to_s.start_with?('find_by_')
      # Handle dynamic finders like find_by_name
      column_name = name.to_s.split('find_by_')[1]
      find_by(column_name: args.first)
    elsif self.class.column_names.include?(name.to_s)
      # Handle attribute methods like name and name=
      # ...
    else
      super
    end
  end
end
```

#### ActiveRecord::Base
remember, around aliases are code that add functionality to an existing method, without around aliasing is a technique that allows you to wrap functionality around an existing method call while still preserving the original behavior 
1. you have an existing method you want to mdify `original_method`
1. define a new method `new_method`, with new behavior that calls the old method 
1. use `alias_method` to alias `original_method`, preserving its behavior
1. use `alias_method` to alias `new_method` with the un-aliased name of `original_method`

```ruby
class MyClass
  def greet_with_log
    puts "Calling method..." greet_without_log
    puts "...Method called"
  end

  alias_method :greet_without_log, :greet
  alias_method :greet, :greet_with_log
end

MyClass.new.greet
=> Calling method... Hello!
=> Method called
```

Rails aliasing code
```ruby
module Module
  def alias_method_chain(target, feature) # target is method to chaiin, feature is new feature
  # Strip out punctuation on predicates or bang methods since
  # e.g. target?_without_feature is not a valid method name. aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1 yield(aliased_target, punctuation) if block_given?
  with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}" , "#{aliased_target}_without_#{feature}#{punctuation}"
  # example, if target is save and feature is validation, with_method will be `save_with_validation` and `without_method` will be save_without_validation.

  alias_method without_method, target # creates a method with the without_method name that has the same behavior as the original target
  alias_method target, with_method # creates a method with the target name that has the same behavior as the with_method.
  case # sets visibility of new target method
    when public_method_defined?(without_method)
      public target
    when protected_method_defined?(without_method)
      protected target
    when private_method_defined?(without_method)
      private target
    end
  end
end
```
^^ Code that write the Rails around aliases


```ruby
module ActiveRecord module Validations
  def self.included(base) base.extend ClassMethods
    base.class_eval do
      alias_method_chain :save, :validation # save is defined as `save_with_validation`, while you can stil call `save_without_validation` manually
      alias_method_chain :save!, :validation
    end
    base.send :include, ActiveSupport::Callbacks
  end
  ```

Recap.

`ActiveRecord::Base` is an open class that includes modules such as ``ActiveRecord::Validations` These modules add class and instance_methods to AR::Base

### 7.3 lessons
 No Java coder in their right mind would ever write a library that consists almost solely of a single huge class with many hundreds of methods.

 thanks to their dynamically typed nature, ActiveRecord’s modules are more decoupled than Java classes and easier to use in isolation. If you only need the valida- tion features, you can include ActiveRecord::Validation in your own class

#### Think in modules
Ways modules add methods

• Include the module in a class, and the methods become instance methods of the class.
• Include the module in the eigenclass of a class, and the methods become class methods.
• Include the module in the eigenclass of any generic object, and the methods become Singleton Methods of the object.

## Ch8 Inside Active Record
We're going to look at dynamic attributes and dynamic finders

### 8.1 Dynamic Attributes

```ruby
require 'activerecord'
ActiveRecord::Base.establish_connection(adapter: "sqlite3" database: "dbfile")
ActiveRecord::Base.connection.create_table :tasks do |t|
  t.string :description
  t.boolean :completed
end

class Task < ActiveRecord::Base; end
task = Task.new
task.description = 'Clean up garage'
task.completed = true

task.save
task.description    # => "Clean up garage"
task.completed?     # => true
```

The previous code calls four Mimic Methods  to access the object’s attributes: two “write” methods (description=() and completed=()), one “read” method (description( )), and one “question” method (completed?( )). None of these “attribute accessors” comes from the definition of Task. So, where do they come from?

#### Ghost attributes

```ruby
def method_missing(method_id, *args, &block)
  method_name = method_id.to_s
  if self.class.private_method_defined?(method_name)
    raise NoMethodError.new("Attempt to call private method", method_name, args)
  end
  # If we haven't generated any methods yet, generate them, then # see if we've created the method we're looking for.
  if !self.class.generated_methods? # the first time we call these we generate methods from the DB columns for the ActiveRecord object
    self.class.define_attribute_methods
  if self.class.generated_methods.include?(method_name)
    return self.send(method_id, *args, &block)
  end
end
```

Below, code to define readers/writers

```ruby
def define_attribute_methods
  return if generated_methods?
  columns_hash.each do |name, column|
    unless instance_method_already_implemented?(name) # safeguard to prevent involuntary monkey patch
      if self.serialized_attributes[name]
        define_read_method_for_serialized_attribute(name)
      elsif create_time_zone_conversion_attribute?(name, column)
        define_read_method_for_time_zone_conversion(name)
      else
        define_read_method(name.to_sym, name, column)
      end
    end

    unless instance_method_already_implemented?("#{name}=") #attr_writers
      if create_time_zone_conversion_attribute?(name, column)
        define_write_method_for_time_zone_conversion(name)
      else
        define_write_method(name.to_sym)
      end
    end

    unless instance_method_already_implemented?("#{name}?")
      define_question_method(name)
    end
  end
end
```

Code for writing attrs
```ruby
def define_write_method(attr_name)
  evaluate_attribute_method(attr_name, "def #{attr_name}=(new_value);write_attribute('#{attr_name}'new_value);end","#{attr_name}=")
end

def evaluate_attribute_method(attr_name, method_definition, method_name=attr_name) #takes an attr_name, string of code for method definition, and method name, calls class eval with the code of string to define writer method
  unless method_name.to_s == primary_key.to_s
    generated_methods << method_name
  end

  begin
    class_eval(method_definition, __FILE__, __LINE__) # File line used for debugging
  rescue SyntaxError => err
  generated_methods.delete(attr_name) 
  end
end
```

When you access an attribute for the first time, that attribute is a Ghost Method. `ActiveRecord:: Base#method_missing` takes this chance to turn the Ghost Method into a real method. While it’s there, `method_missing` also dynamically defines read, write, and question accessors for all the other database columns. The next time you call that attribute, or another database-backed attribute, you find a real accessor method waiting for you, and you don’t enter `method_missing`.

#### Attributes that stay dynamic
Sometimes we dont want to define accessors—for example, for attributes that are not backed by a database column, like calculated fields.

```ruby # continuation of above method missing
def method_missing(method_id, *args, &block)
# ...
  if self.class.primary_key.to_s == method_name
    id # if the method is id, return id
  elsif md = self.class.match_attribute_method?(method_name) # applies a regular expression to check whether the name of the method you called ends with a known extension (such as ? or =) and returns a MatchData object. Then it uses the extension to build the name of a “handler method,” like `attribute?` or `attribute=`, and it calls the handler with a Dynamic Dispatch.
    attribute_name, method_type = md.pre_match, md.to_s
    if @attributes.include?(attribute_name)
      __send__("attribute#{method_type}", attribute_name, *args, &block)
    else
      super
    end
  elsif @attributes.include?(method_name)
    read_attribute(method_name)
  else
    super # will raise attribute missing error, unless method missing overwritten higher up
  end
end
```

#### ActiveRecord::Base#respond_to?
If we alter method missing, we should probablyh alter `respond_to`
For example, if I can call my_task.description( ), then I expect that `my_task. respond_to?(:description)` returns true. Here is the redefined `respond_to?` of `ActiveRecord::Base`

```ruby
def respond_to?(method, include_private_methods = false)
  method_name = method.to_s
  if super
    return true #responds if parent implements
  elsif !include_private_methods && super(method, true)
  # If we're here than we haven't found among non-private methods
  # but found among all methods. Which means that given method is private.
    return false
  elsif !self.class.generated_methods? # if generated methods arent present, generate them
    self.class.define_attribute_methods
    if self.class.generated_methods.include?(method_name)
      return true
    end
  end

  if @attributes.nil? # delegate to parent
    return super
  elsif @attributes.include?(method_name)  # return true since it's an attr
    return true
  elsif md = self.class.match_attribute_method?(method_name) #Perform same regex check as `method_missing`
    return true if @attributes.include?(md.pre_match)
  end

  super
end
```

### 8.2 Dynamic finders
ActiveRecord offers an elegant alternative to `find` with so-called dynamic finders, which let you specify attributes right in the method name:

```ruby
Task.find_all_by_completed(true)
Task.find_by_description_and_completed('Clean up garage', true)
Task.find_or_create_by_description('Water plants')
```

Dynamic finders are class methods, so you have to look for the class’s `method_missing`, not the instances’ `method_missing`.

DENSE BIG METHOD COME BACK FRESH

#### ActiveRecord::Base.respond_to?

Consistent with `ActiveRecord::Base#method_missing`, in the sense that it knows about dynamic finders and other Ghost Methods

```ruby
class ActiveRecord::Base
  class << self # Class methods
    def respond_to?(method_id, include_private = false)
      if match = DynamicFinderMatch.match(method_id) #check dynamic finder
        return true if all_attributes_exists?(match.attribute_names)
      elsif match = DynamicScopeMatch.match(method_id) #check dynamic scopde
        return true if all_attributes_exists?(match.attribute_names)
      end
      super # delegate probably to  default respond_to? method provided by Ruby
    end
  #...
```

### 8.3 Lessons learned

#### Don't Obsess over performance
profile their code in a real-life system to discover where the performance bottlenecks are, THEN optimize

Calling a real method is faster than calling a Ghost Method, so Rails chooses to define real methods to access attributes. On the other hand, defining a method also takes time, so Rails doesn’t do that until it’s sure that you really want to access at least one attribute on your ActiveRecord objects.

#### Draw your own line

 The mechanism for dynamic attributes in Rails is relatively simple and clean, considering how complex the feature itself is. On the other hand the code behind dynamic finders relies on evaluating complicated strings, and I wouldn’t exactly jump at the chance to maintain that code.

 ### Complexity for Beginners vs. Complexity for Experts
 For an experienced Ruby coder, metaprogramming code can actually look simple and perfectly readable. Remember, though, that not everybody is as familiar with metaprogramming.

 #### Internal Complexity vs. External Complexity
 If you stripped all meta- programming out of ActiveRecord, you’d end up with a tamer code base, but the library itself wouldn’t be nearly as simple to use. You’d miss all the magic methods like `task.completed=` or `Task.find_by_description`.

 Common trade off by making the insides of your code more complex, you make your library simpler for clients.

 #### Complexity by Terseness vs. Complexity by Duplication

 One of the basic principles of the Rails philosophy is “don’t repeat yourself,” and the dynamic finders code makes a choice that’s consistent with that principle.

 #### Complexity for Humans vs. Complexity for Tools

 Ruby’s dynamic nature makes life hard for refactoring engines or code analysis tools. That’s why some IDE features that work great for static languages (such as finding all the calls to a method, renaming a variable, or jumping from a method usage to its definition) are difficult to implement well in Ruby. 

 One of the fundamental trade-offs of metaprogramming (and, to a point, of dynamic languages). You have the freedom to write expressive, terse code, but to read that code, you need a human brain.

 ## Ch9 Metaprogramming safely
 Metaprogramming gives you the power to write beautiful, concise code.
 Metaprogramming gives you the power to shoot yourself in the foot. 