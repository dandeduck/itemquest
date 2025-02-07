SELECT price, avatar_image_url, name
FROM market_listings
LEFT JOIN users ON market_listings.user_id = users.user_id
WHERE item_id = $1 AND listing_type = 'sell'
ORDER BY market_listings.price DESC
LIMIT $2 OFFSET $3;
