# Sum two number in array.

## Description

Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

## Ideal solution

O(n) time, Iteraates over array 1x. Hash lookups are constant time.
O(n) space. Hash grows linearly as number of elements increases

```ruby
def two_sum(nums, sum)
  lookup = {}

  nums.each_with_index do |addend, index|
    compliment = sum - addend
    return [lookup[compliment], index] if lookup[compliment] # return value stored in lookup(compliment) and current index
    lookup[addend] = index # add value to lookup unless its compliment is present
  end
end
```

## Initial solution

O(1) space, just some simple variable assignment
O(n^2) Time, as we iterate over nums, calling `nums.find_index(addend_2)` which is a linear search.

```ruby
def two_sum(nums, sum)
  lookup = {}
  nums.each_with_index do |addend_1, index|
    addend_2 = sum - addend_1
    index2 = nums.find_index(addend_2)
    return [index2, index] unless index2==index
  end
end
```