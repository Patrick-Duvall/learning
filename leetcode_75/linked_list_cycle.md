Given head, the head of a linked list, determine if the linked list has a cycle in it.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the next pointer. Internally, pos is used to denote the index of the node that tail's next pointer is connected to. Note that pos is not passed as a parameter.

Return true if there is a cycle in the linked list. Otherwise, return false.

 

Example 1:

Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed).

## Initial

```ruby
# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val)
#         @val = val
#         @next = nil
#     end
# end

# @param {ListNode} head
# @return {Boolean}
def hasCycle(head)
    map = {}
    current_node = head

    until current_node&.next.nil?
        map[current_node] = true

        current_node = current_node.next

        return true if map.has_key?(current_node)
    end

    false

    
end
```

## Ideal

Floyds Cycle Finding algorithm. 

2 pointers, one goes 2 at a time, one goes one at a time.

If theres a loop, fast will hit it and lap slow from behind.

```ruby 
# My initial 

def hasCycle(head)
    slow_node = head
    fast_node = head

    until slow_node&.next.nil? && fast_node&.next.nil? # potential bug. Loop runs until both nil. this assigns fast_node to nil below
    # fast node is now permanently nil till slow node becomes_nil, in a false positive
        fast_node = fast_node&.next&.next 
        slow_node = slow_node&.next

        return true if slow_node == fast_node
    end

    false

end
```

Fix

```ruby
def hasCycle(head)
    return false if head.nil? || head.next.nil? # break early

    slow_node = head
    fast_node = head

    while !fast_node.nil? && !fast_node.next.nil?
    # fast node is now permanently nil till slow node becomes_nil, in a false positive
        fast_node = fast_node.next.next 
        slow_node = slow_node.next

        return true if slow_node == fast_node
    end

    false
end
```