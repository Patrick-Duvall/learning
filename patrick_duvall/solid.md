# SOLID

### Single Responsibility Principle

### Open Closed

This is basically abstracting the thing that changes and giving it a shared public interface. The abstraction of the thing that changes can happen in a few ways(factory pattern, inheritance, dependency injection). When done correctly Adding new behavior is as simple as adding a new file/class that represents the changing abstraction.

A basic example with inheritance

```ruby

# Define a shared role/public interface
class Shape
  def initialize(**kwargs)
    raise NotImplementedError, 'Subclasses must implement the initialize method'
  end

  def area
    raise NotImplementedError, 'Subclasses must implement the area method'
  end
end

# Implement specific shapes by extending the shared interface
class Circle < Shape
  def initialize(radius:)
    @radius = radius
  end

  attr_reader: :radius

  def area
    Math::PI * radius**2
  end
end

class Rectangle < Shape
  def initialize(width:, height:)
    @width = width
    @height = height
  end

  attr_reader: :width, :height

  def area
    width * height
  end
end

class ShapeFactory
  def self.create_shape(type, **kwargs)
    case type
    when :circle
      Circle.new(**kwargs)
    when :rectangle
      Rectangle.new(**kwargs)
    else
      raise "Unknown shape type: #{type}"
    end
  end
end
```

Then, if we want to extend the functionality of shapes, we add a new shape class(the thing that changes), and a new condition to the ShapeFactory(The thing that is aware of the changing thing).

```ruby
class ShapeFactory
  def self.create_shape(type, **kwargs)
    ...
    when :triangle
      Triangle.new(**kwargs)
    ...
    end
  end
end

class Triangle < Shape
  def initialize(base:, height:)
    base = base
    height = height
  end

  attr_reader: :width, :height

  def area
    0.5 * base * height
  end
end
```


This allows users of shapes to continue to use them as we add new shapes.

```ruby
shapes = [
  ShapeFactory.create_shape(:circle, radius: 5),
  ShapeFactory.create_shape(:rectangle, width: 10, height: 5),
  ShapeFactory.create_shape(:triangle, base: 6, height: 8)
]

shapes.each do |shape|
  puts shape.area
end
```
