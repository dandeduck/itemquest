SELECT market_listings.price, users.avatar_image_url, users.name
FROM market_listings
LEFT JOIN users
ON market_listings.user_id = users.user_id
WHERE market_listings.item_id = $1 AND market_listings.listing_type = 'sell'
ORDER BY market_listings.price DESC
LIMIT $2 OFFSET $3;
