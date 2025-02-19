SELECT price, user_id, listing_type
FROM market_listings
WHERE item_instance_id = $1;
