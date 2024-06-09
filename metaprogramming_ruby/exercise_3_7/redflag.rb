def event(name, &block)
  @events[name] = block
end

def setup(&block)
  @setups << block
end

@setups = []
@events = {}

event "the sky is falling" do
  @sky_height < 300
end

event "it's getting closer" do
  @sky_height < @mountains_height
end

setup do
  puts "Setting up sky"
  @sky_height = 100
end

setup do
  puts "Setting up mountains"
  @mountains_height = 200
end

@events.each do |name, event|
  @setups.each do |setup|
    setup.call # calls the setup block(setting the instance variable)
  end
  # Calls the event block which evaluates to a boolean
  # To determine if the alert is output.
  puts "ALERT: #{name}" if event.call 
end