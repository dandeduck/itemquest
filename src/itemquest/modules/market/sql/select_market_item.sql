SELECT name, image_url, price
FROM market_items
WHERE item_id = $1;
