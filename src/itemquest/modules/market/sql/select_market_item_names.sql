
-- Select market item names with (name)
SELECT name, ts_rank(name_search, to_tsquery($2)) as rank
FROM market_items 
WHERE market_id = $1 AND name_search @@ to_tsquery($2)
ORDER BY rank DESC
LIMIT 10;
