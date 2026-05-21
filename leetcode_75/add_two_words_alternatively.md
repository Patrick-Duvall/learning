# Problem

You are given two strings word1 and word2. Merge the strings by adding letters in alternating order, starting with word1. If a string is longer than the other, append the additional letters onto the end of the merged string.

Return the merged string.

 

Example 1:

Input: word1 = "abc", word2 = "pqr"
Output: "apbqcr"
Explanation: The merged string will be merged as so:
word1:  a   b   c
word2:    p   q   r
merged: a p b q c r

## Initial
```ruby
def merge_alternately(word1, word2)
    num_times = [word1.length, word2.length].min
    word3 = ""
    num_times.times do
        word3 += word1.slice!(0)
        word3 += word2.slice!(0)
    end
    word3 += word1
    word3 += word2
    word3
end
```

## Optimal
```ruby
def merge_alternately(word1, word2)
  merged = []
  min_len = [word1.length, word2.length].min

  # 1. Zip the alternating characters up to the min length
  min_len.times do |i|
    merged << word1[i]
    merged << word2[i]
  end

  # 2. Convert the array to a string and slice the remainders
  # word1[min_len..] grabs everything from min_len to the end of the string
  merged.join + word1[min_len..] + word2[min_len..]
end
```

No String Shifting: word1[i] is a direct lookup by index, which is a constant-time $O(1)$ operation. The original strings are left completely intact.
Array Pushing is Fast: Appending an element to an array using << is an amortized $O(1)$ operation.

Single Allocation: merged.join combines all elements into the final string in a single, highly optimized C-level memory allocation inside the Ruby runtime.