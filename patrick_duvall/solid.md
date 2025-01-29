# SOLID

### Single Responsibility Principle

## Open Closed

This is basically abstracting the thing that changes and giving it a shared public interface. The abstraction of the thing that changes can happen in a few ways(factory pattern, inheritance, dependency injection). When done correctly Adding new behavior is as simple as adding a new file/class that represents the changing abstraction.

### What Design Problems Does It Solve?

1. Reduces the risk of breaking existing functionality
- If you modify a class directly, there’s a risk of introducing unintended side effects.
1. Encourages scalability and maintainability
- By keeping the original implementation untouched and extending behavior through well-defined interfaces or patterns, it’s easier to accommodate future changes.
1. Supports code reuse and flexibility
- New features can be added without requiring major refactoring.


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

### Another example using modules for extension

```ruby
class Logger
  def log(message)
    puts message
  end
end
```

Extending Logger functionality without modifying the class(Adding Timestamping Decorator)

```ruby
module TimestampedLogger
  def log(message)
    super("[#{Time.now}] #{message}")
  end
end

logger = Logger.new
logger.extend(TimestampedLogger)
logger.log("This is a log message.")
```

### Using Dependency Injection

Here we change the thing injected, which changes the output of the report class. If we want another type of report, we create another formatter and inject it into the report.

```ruby
class Report
  def initialize(formatter)
    @formatter = formatter
  end

  def generate(data)
    @formatter.format(data)
  end
end

class JSONFormatter
  def format(data)
    data.to_json
  end
end

class XMLFormatter
  def format(data)
    data.to_xml
  end
end

# Usage
report = Report.new(JSONFormatter.new)
puts report.generate({ name: 'John', age: 30 })

report = Report.new(XMLFormatter.new)
puts report.generate({ name: 'John', age: 30 })
```

### Real-World Open Source Examples

1. RSpec Matchers lets users define custom matchers without modifying existing ones.
1. Rails follows OCP by allowing developers to extend model behavior using callbacks (before_save, after_create) without modifying the core ActiveRecord class.
1. Sidekiq allows users to extend worker behavior (e.g., logging, error handling) using middleware instead of modifying the main job processing logic.
