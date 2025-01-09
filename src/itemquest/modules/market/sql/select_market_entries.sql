-- Select market entries with (market_id, sort_by, sort_direction, limit, offset)
SELECT market_entries.*, items.name, items.image_url
FROM items 
INNER JOIN market_entries ON items.item_id=market_entries.item_id
WHERE items.market_id = $1
ORDER BY 
    (CASE WHEN $3 = 'ASC' AND $2 = 'price' THEN market_entries.price END) ASC NULLS FIRST,
    (CASE WHEN $3 = 'DESC' AND $2 = 'price' THEN market_entries.price END) DESC NULLS LAST,
    (CASE WHEN $3 = 'ASC' AND $2 = 'quantity' THEN market_entries.quantity END) ASC,
    (CASE WHEN $3 = 'DESC' AND $2 = 'quantity' THEN market_entries.quantity END) DESC
LIMIT $4 OFFSET $5;
