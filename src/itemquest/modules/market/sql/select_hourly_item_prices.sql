-- Selects all price+time rows by (item_id) using hourly_item_prices view
SELECT price, time
FROM hourly_item_prices
WHERE item_id = $1;
