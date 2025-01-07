DROP TABLE IF EXISTS  market_entries, item_instances, items, waitlist_emails, markets;
DROP TYPE IF EXISTS item_status, market_status;

CREATE TYPE item_status AS enum (
    'published',
    'unpublished'
);

CREATE TYPE market_status AS enum (
    'live',
    'development'
);

CREATE TABLE markets (
    market_id  serial PRIMARY KEY,
    status     market_status NOT NULL DEFAULT 'development',
    name       varchar(31) NOT NULL,
    image_url  varchar(255),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE items (
    item_id    serial PRIMARY KEY, 
    market_id  serial REFERENCES markets,
    status     item_status NOT NULL DEFAULT 'unpublished',
    name       varchar(31) NOT NULL,
    image_url  varchar(255),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE item_instances (
    item_instance_id serial PRIMARY KEY, 
    item_id          serial REFERENCES items,
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE market_entries (
    item_id   serial PRIMARY KEY REFERENCES items, 
    quantity  integer NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    price     integer CHECK (price > 0)
);

CREATE TABLE waitlist_emails (
    address    varchar(255) PRIMARY KEY,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);
