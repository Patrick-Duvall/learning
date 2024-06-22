# class MyClass < Array
#   def my_method
#     'Hello!'
#   end
# end

# Write the same thing as the above code without using the class keyword.

klass = Class.new(Array) do
  def my_method
    'Hello!'
  end
end

MyClass = klass