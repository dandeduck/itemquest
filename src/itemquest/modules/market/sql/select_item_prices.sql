-- Interval can be 'max', 'hour', 'day'. Based on this runs on the relevant view/table
SELECT price, time
FROM market_sales
WHERE $2 = 'max' AND item_id = $1 AND time >= NOW() - INTERVAL '1 day'
UNION ALL 
SELECT price, time
FROM hourly_item_prices
WHERE $2 = 'hour' AND item_id = $1
UNION ALL  
SELECT price, time
FROM daily_item_prices
WHERE $2 = 'day' AND item_id = $1;

