# break the rules of math by redefining Fixnum#+( ) so that it always returns the correct result plus one, i.e.
# 1 + 1 # => 3

class Fixnum
  alias_method :old_plus, :+

  def +(value)
    old_plus(value).old_plus(1)
  end
end

puts 1 + 1