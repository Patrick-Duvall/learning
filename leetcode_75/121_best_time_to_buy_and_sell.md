# Best time to Buy and Sell

## Description

You are given an array prices where prices[i] is the price of a given stock on the ith day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.

### Constraints:

1 <= prices.length <= 105
0 <= prices[i] <= 104

## Initial solution

Iterate over the collection of prices, setting the initial `min_price` to the first price. For each subsequent price, if it is lower than anything we've seen, we want to buy at that new low. So update min_price.
Otherwise if the new price is higher or equal, we could sell now, so compute the profit from buying at min_price and update max_profit if that profit is better.

O(1) Space, storing values for min_price and max_profit
O(n) Time, iterate once over prices array once

```ruby
def max_profit(prices)
    max_profit = 0
    min_price = prices[0]
    prices.each do |current_price|
        if current_price < min_price
          min_price = current_price
        else
          profit = current_price - min_price
          max_profit = [profit, max_profit].max
        end
    end

    max_profit
end
```

### Optimal solution

```ruby
def max_profit(prices)
    min_price = Float::INFINITY
    max_profit = 0
    prices.each do |price|
        if price < min_price
            min_price = price
        end
        
        if max_profit < price - min_price
            max_profit = price - min_price
        end
    end
    max_profit
end
```

Same essential algorithm of iterate over collection, storing the minimum price and the maximum profit then returning the `max_profit`

O(1) Space, storing values for min_price and max_profit
O(n) Time, iterate once over prices array once

Avoids [].max? (operation), and prices[0](lookup), for minor savings.