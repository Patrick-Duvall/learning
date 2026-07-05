There are n kids with candies. You are given an integer array candies, where each candies[i] represents the number of candies the ith kid has, and an integer extraCandies, denoting the number of extra candies that you have.

Return a boolean array result of length n, where result[i] is true if, after giving the ith kid all the extraCandies, they will have the greatest number of candies among all the kids, or false otherwise.

Note that multiple kids can have the greatest number of candies.


```ruby
# @param {Integer[]} candies
# @param {Integer} extra_candies
# @return {Boolean[]}
def kids_with_candies(candies, extra_candies)
    return_value = []

    max_candies = candies.max

    candies.each do |candy|
        if candy + extra_candies >= max_candies
            return_value << true
        else
            return_value << false
        end
    end
    return_value
end
```

Version with less boilerplate, same 2 pass algorithm of find max, check max

```ruby
def kids_with_candies(candies, extra_candies)
    max_candies = candies.max
    candies.map { |candy| candy + extra_candies >= max_candies }
end
```