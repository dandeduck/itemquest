INSERT INTO market_items(item_id, market_id, name, image_url)
SELECT item_id, market_id, name, image_url
FROM items
WHERE item_id = $1
