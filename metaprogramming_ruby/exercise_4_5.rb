#when a class includes a module, it gets the module’s instance methods, not the class methods.
#Class methods stay out of reach, in the module’s eigenclass.”

module MyModule
  def self.my_method;
    'hello';
  end

  def my_method;
    'hello2';
  end
end

class MyClass
  # include MyModule
  class << self
    include MyModule
  end
end
  
MyClass.my_method   # NoMethodError!
MyClass.new.my_method   # NoMethodError!

#### Book Solution

class MyClass
  class << self
    include MyModule
  end
end

#BUT
MyClass.new.my_method   # NoMethodError!

### Solution for both

module MyModule
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def my_class_method
      'hello from class method'
    end
  end

  def my_instance_method
    'hello from instance method'
  end
end

class MyClass
  include MyModule
end

puts MyClass.my_class_method  # Outputs: hello from class method

object = MyClass.new
puts object.my_instance_method  # Outputs: hello from instance method

