DROP MATERIALIZED VIEW IF EXISTS hourly_item_prices, daily_item_prices;

CREATE MATERIALIZED VIEW hourly_item_prices AS
SELECT DISTINCT ON (item_id, date_trunc('hour', created_at))
    item_id, 
    created_at AS time,
    price
FROM market_sales
WHERE created_at >= NOW() - INTERVAL '1 week'
ORDER BY item_id, date_trunc('hour', created_at), created_at DESC;

CREATE MATERIALIZED VIEW daily_item_prices AS
SELECT DISTINCT ON (item_id, date_trunc('day', created_at)) 
    item_id,
    created_at AS time,
    price
FROM market_sales
ORDER BY item_id, date_trunc('day', created_at), created_at DESC;

CREATE INDEX idx_item_prices_hourly_item_id ON hourly_item_prices (item_id);
CREATE INDEX idx_item_prices_daily_item_id ON daily_item_prices (item_id);
