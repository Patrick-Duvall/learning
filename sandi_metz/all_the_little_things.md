# All the little things talk

Replace conditionals with small objects

Gilded rose Kata

Dont be paralyzed by the fear that you have to understand everything to change anything

Squint test: changes in color, changes in shape (shape = nested conditionals, color = diff levels abstraction)

Novices tend to find the place the change is needed and add another conditional. Code reaches a tipping point where you cant imagine putting the code anywhere else.

I dont need to understand it, I have tests

Tests are the wall at your back

Objects create seams,  place where you can alter the behavior of a system without modifying the code itself. Seams are useful for testing, refactoring, and extending software systems. They allow you to insert dependencies, mock objects, or different implementations without directly changing existing code.

Refactor under green, get the easiest behavior that allows tests to pass(either existing, or writing new describing current behavior if missing functionality)
Red is the wrong time to ponder the abstraction.

```ruby
class GildedRose
  def tick
    if name == 'normal'
      return normal_tick
    end

    # rest of deeply neseted conditional
  end

  def normal_tick
    @days_remaining -= 1
    return if @quality == 0

    @quality -= 1
    @quality -= 1 if @days_remaining <= 0
  end
end
```

Continue to break out conditions into their own branches

```ruby
def tick
  case name
  when 'normal'
    return normal_tick
  when 'aged_brie'
    return brie_tick
  end
  # ...
end

def brie_tick
  @days_remaining -= 1
  return if @quality >= 50

  @quality += 1
  @quality += 1 if @days_remaining <= 0
end
```

DO NOT break out into the the abstraction yet.
Cheaper to deal with duplication than wrong abstraction. Tolerate duplication, wait for right abstraction.

Create Dupe tags with Ids i.e. `# Duplication 3` 

If you have code you dont understand and are afraid to change create a test harness, characterization specs around edges.

Metrics are faliable, but human opinion is no more precise. If you are at the intersection of these two, you are likely correct.

Intermediate refactorings can make code more complex.

### Is case statement with individual method ticks the path forward to implement conjured?

- It is not open/closed

Arrange code so new behavior is addable without changind existing code.

repeating prefix or suffix: tortured object

```ruby
class Normal
  attr_reader :quality, :days_remaining

  def initialize(quality, days_remaining)
    @quality, @days_remaining = quality. days_remaining
  end

  def tick
    @days_remaining -= 1
    return if @quality == 0

    @quality -= 1
    @quality -= 1 if @days_remaining <= 0
  end
end

class Gilded Rose
  def normal_tick
    @item = Normal.new(quality, days_remaining)
    @item.tick
  end


  # intermediate complexity to make existing case statement work while some ticks are objects and some are methods on GildedRose
  def quality
    item ? item.quality : quality
  end

  def days_remaining
    item ? item.days_remaining : days_remaining
  end
end
```

Take the individual methods and put them into the conditional, then change gilded rose so it always holds to an item. Rose has become an item factory, with the role of determining what item to generate based on a name string.

This seperates 'reason for switching'(1 responsibility) from 'thing I do when I switch' (another)

```ruby
  class GildedRose
  attr_reader :item

    def initialize(quality, days_remaining)
      @item = klass_for(name).new(quality, days_remaining)
    end

    def klass_for(name)
      case name
      when 'normal'
        Normal
      when 'Aged Bried'
        Brie
      when 'Sulfuros'
        Sulfuros
      when 'Backstage Passes'
        Backstage
      end
    end

    def tick
      item.tick
    end

    def quality = item.quality
    def days_remaining = item.days_remaining
  end
```

Item is a role. If delegating to item was Gilded Roles only responsibility, it probably shouldnt exist BUT it plays he factory role.

If an objects only purpose is to forward methods, question if it justifies existing.

Change GildedRose to a module, remove the middleman methods

```ruby
  module GildedRose
    def self.for(name, quality, days_remaining)
      @item = klass_for(name).new(quality, days_remaining)
    end

    def self.klass_for(name)
      case name
      when 'normal'
        Normal
      when 'Aged Bried'
        Brie
      when 'Sulfuros'
        Sulfuros
      when 'Backstage Passes'
        Backstage
      end
    end  
  end

  #Usage

  item = GildedRose.for('Normal', 10, 15)
  item.tick
```

Gilded rose is an item factory, switch from knowing what the thing does, to getting the thing and trusting it to do it

### Turn to Classes that play common role

Extract shared code

```ruby
class Item
  attr_reader :quality, :days_remaining

  def initialize(quality, days_remaining)
    @quality, @days_remaining = quality. days_remaining
  end

  def tick ## This lets us delete Sulfuros Class which had a similar no-op on tick
  end
end

class Normal < Item
  def tick
  #...
  end
end

class Brie < Item
  def tick
  #...
  end
end

#... other item subclasses
```

Inheritance safe in shallow, narrow heirarchy, subclasses at leaf node of object graph

Shallow, narrow subclasses at leaf node that use all behavior of super class

Extract case statements to configuration information: Hash or yml

```ruby
module GildedRose
  DEFAULT_CLASS = Item
  SPECIALIZED_CLASSES =  {
    'normal' => Normal,
    'Aged Brie' => Brie,
    'backstage tickets', => Backstage
  } # now hash  can change independently of algorithm

  def self.for(name, quality, days_remaining)
    (SPECIALIZED_CLASSES[name] || DEFAULT_CLASS).new(quality, days_remaining)
  end
end
```
Conjured is now laughably simple, make a subclass with #tick logic.

Dont reach for the future, right code that can adapt to the futurewhen it arrives.

Metrics are useful but they're faliable, opinions are no more precise. Operate at the intersection of these, and you're likely correct.
