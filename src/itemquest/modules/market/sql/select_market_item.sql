SELECT item_id, name, image_url, price
FROM market_items
WHERE item_id = $1 AND market_id = $2;
