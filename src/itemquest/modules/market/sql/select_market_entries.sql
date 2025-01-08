-- Select market entries with (market_id, order_query, limit, offset)
SELECT market_entries.*, items.name, items.image_url
FROM items 
INNER JOIN market_entries ON items.item_id=market_entries.item_id
WHERE items.market_id = $1
ORDER BY $2
LIMIT $3 OFFSET $4;
