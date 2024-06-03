# Nothing is something

1 + 1, syntactic sugar 1.send(:+, 1)

True is an object

if truthy do X  is a type check (not OO)

if is an enabler

Do not need a special syntax in OO language to deal with booleans

How would you think about objects if there were no 'if' statement

Sometimes nil is nothing
- compact in this case

try is really a type switch on class
```ruby
class Animal
  attr_reader: name
end

class MissingAnimal
  def name 'no animal' end
end

class GuaranteedAnimal
  def self.find(id)
    Animal.find(id) || MissingAnimal.new
  end
end
```

null object pattern: active nothing

Problem with inheritence is when you want the cross-polination of two subclasses
duplicate all code from other subclasses into new subclass ?

Inheritance is for specialization, it is not for sharing code

Reveal how classes are different by making them more alike

Composition: inject an object to play the role of the thing that varies

House that Jack built
House
RandomHouse
EchoHouse

Task: Implement Random Echo

| Class | Data | Order |
|----------|----------|----------|
| House   | Data   | default # This order algorithim   |
| RandomHouse   | Data   | shuffle   |

``` ruby
# DATA = lines of 'House that Jack Built'

class RandomOrder
  def order(data)
    data.shuffle
  end
end

class DefaultOrder
  def order(data); data ; end
end

class House
  attr_reader :data

  def initialize(orderer: DefaultOrderer.new)
    @data = orderer.order(DATA)
  end
end

# Implement Echo House

class EchoFormatter
  def format(parts)
    parts.zip(parts.flatten)
  end
end

class DefaultFormat
  def format(parts); parts ; end
end

class House
  attr_reader :data

  def initialize(orderer: DefaultOrderer.new, formatter: DefaultFormatter.new)
    @data = orderer.order(DATA)
    @formatter = formatter
  end
end
```

Composition: Inject an object to play the role of the thing that varies

Theres no such thing as one specialization, isolate the thing that varies
If you have a thing that varies, you dont have one specialization, you have two, name that variance and inject it as a dependency
