# Valid anagram

## Description

Given two strings s and t, return true if t is an anagram of s, and false otherwise.

### Initial

O(n) Space, creating 2 arrays based on length of string (sort also takes O(n) space)
O(n log n) Time Sorting is linearithmic, meaning as the size increases, tme increases by size * log size

``` ruby
def is_anagram(one, two)
  return false unless one.length == two.length

  letters_1 = one.split('').sort
  letters_2 = two.split('').sort

  letters_1 == letters_2
end
```

### Ideal

O(n) Space, hash stores charachter frequencies. Worst case, every char is unique
O(n) Time, iterate once over each char of each string, and values in `.all?`

```ruby
def is_anagram(one, two)
  return false unless one.length == two.length

  count = Hash.new(0)

  one.chars.each{|char| count[char] += 1 }
  two.chars.each{|char| count[char] += 1 }

  count.values.all?(&:zero?)
end
```