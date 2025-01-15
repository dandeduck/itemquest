-- Select market items with (market_id, search, sort_by, sort_direction, limit, offset)
SELECT name, image_url, quantity, popularity, price
FROM market_items 
WHERE market_id = $1 AND CASE WHEN $2 != '' THEN name_search @@ to_tsquery($2) ELSE TRUE END
ORDER BY 
    (CASE WHEN $4 = 'ASC' AND $3 = 'popularity' THEN popularity END) ASC,
    (CASE WHEN $4 = 'DESC' AND $3 = 'popularity' THEN popularity END) DESC,
    (CASE WHEN $4 = 'ASC' AND $3 = 'price' THEN price END) ASC NULLS FIRST,
    (CASE WHEN $4 = 'DESC' AND $3 = 'price' THEN price END) DESC NULLS LAST,
    (CASE WHEN $4 = 'ASC' AND $3 = 'quantity' THEN quantity END) ASC,
    (CASE WHEN $4 = 'DESC' AND $3 = 'quantity' THEN quantity END) DESC
LIMIT $5 OFFSET $6;
