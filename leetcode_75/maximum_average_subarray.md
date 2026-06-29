# 643. Maximum Average Subarray I


You are given an integer array nums consisting of n elements, and an integer k.

Find a contiguous subarray whose length is equal to k that has the maximum average value and return this value. Any answer with a calculation error less than 10-5 will be accepted.

 

Example 1:

Input: nums = [1,12,-5,-6,50,3], k = 4
Output: 12.75000
Explanation: Maximum average is (12 - 5 - 6 + 50) / 4 = 51 / 4 = 12.75
Example 2:

Input: nums = [5], k = 1
Output: 5.00000
 

Constraints:

n == nums.length
1 <= k <= n <= 105
-104 <= nums[i] <= 104

```ruby
def find_max_average(nums, k)
    sum = nums[0...k].sum
    maximum = sum

    nums.each_with_index do |num,index|
        next if index == 0
        break if index > (nums.length - k) 
        entering = nums[index + k -1]
        exiting = nums[index -1]

        sum += entering
        sum -= exiting

        maximum = sum if sum > maximum
        
    end
    maximum.to_f / k
end
```

# Add start of array unshift
# add end <<