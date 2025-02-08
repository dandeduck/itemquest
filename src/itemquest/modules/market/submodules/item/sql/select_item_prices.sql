-- Interval can be 'max', 'hour', 'day'. Based on this runs on the relevant view/table
(
    SELECT price, extract(epoch from time)::int as timestamp
    FROM market_sales
    WHERE $2 = 'max' AND item_id = $1 AND time >= NOW() - INTERVAL '30 day' -- todo fix this to 1 day(?)
    UNION ALL 
    SELECT price, extract(epoch from time)::int as timestamp
    FROM hourly_item_prices
    WHERE $2 = 'hour' AND item_id = $1
    UNION ALL  
    SELECT price, extract(epoch from time)::int as timestamp 
    FROM daily_item_prices
    WHERE $2 = 'day' AND item_id = $1
    ORDER BY timestamp
)
UNION ALL
SELECT price, extract(epoch from CURRENT_TIMESTAMP)::int as timestamp
FROM market_items
WHERE $2 != 'max' AND item_id = $1 AND price IS NOT NULL;
