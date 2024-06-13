def event(name, &block)
  @events[name] = block
end

def setup(&block)
  @setups << block
end

@setups = []
@events = {}

setup do
  puts "Setting up sky"
  @sky_height = 100
end

setup do
  puts "Setting up mountains"
  @mountains_height = 200
end

event "the sky is falling" do
  @sky_height < 300
end

event "it's getting closer" do
  @sky_height < @mountains_height
end

@events.each_pair do |name, event|
  env = Object.new
  @setups.each do |setup|
    env.instance_eval &setup
  end
  puts "ALERT: #{name}" if env.instance_eval &event
end

# event( ) and setup( ) convert the block to a proc with the & operator.
# Then they store away the proc, in @events and @setups, respectively.
# These two top-level instance variables are shared by event(), setup(), and the main code.

# Evaluation in the context of a clean room means ivars are ivars of the object and dont pollute
# Thhe shared top level space

# Problem ivars are essentially global variables