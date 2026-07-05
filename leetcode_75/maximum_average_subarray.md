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

---

## Explanation

### Key insight

Every candidate subarray has the **same length** `k`. Since the average is
`sum / k` and `k` is constant, the window with the largest *sum* also has the
largest *average*. So the problem reduces to: **find the maximum sum of any
window of length `k`.**

### Sliding window

A sliding window is a fixed-width chunk of the array that moves left to right.
The naive approach recomputes each window's sum from scratch (`O(n * k)`). The
sliding window avoids that: when the window shifts one step right, only two
elements change — one **enters** at the right edge, one **exits** at the left
edge. Update the running sum in `O(1)` instead of re-adding everything.

```
[ 1   12   -5   -6   50   3 ]   k = 4
  └──────────────┘                window sum = 2
       └──────────────┘           drop 1, add 50 -> 51
            └──────────────┘      drop 12, add 3 -> 42
```

When the window's new start is at `index`:

- **entering** = element at the right edge = `nums[index + k - 1]`
- **exiting**  = element falling off the left = `nums[index - 1]`

### Algorithm

1. Compute the sum of the first window (`nums[0...k]`); seed `maximum` with it.
2. Slide one position at a time. Each slide: add the entering element, subtract
   the exiting one — **always**, so the running sum stays valid.
3. Track the largest window sum seen.
4. Return `maximum.to_f / k` (use a float — integer division would truncate).

### Common pitfalls

- **Swapping entering/exiting.** Entering is the *right* edge
  (`nums[index + k - 1]`); exiting is the *left* edge (`nums[index - 1]`).
- **Updating the sum conditionally.** The running `sum` must always equal the
  current window's sum — update it every slide, compare against the max separately.
- **Integer division.** `sum / k` truncates when both are integers; use
  `sum.to_f / k`.

### Complexity

- Time: `O(n)` — each element enters and leaves the window once.
- Space: `O(1)` — only a running sum and a max are stored.