-- Selects all price+time rows by (item_id) using daily_item_prices view
SELECT price, time
FROM daily_item_prices
WHERE item_id = $1;
