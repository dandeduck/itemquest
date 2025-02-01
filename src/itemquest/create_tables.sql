DROP TABLE IF EXISTS   market_sales, market_listings, market_items, item_instances, items, waitlist, markets, users;
DROP TYPE IF EXISTS item_status, market_status;

CREATE TYPE item_status AS enum (
    'published',
    'unpublished'
);

CREATE TYPE market_status AS enum (
    'live',
    'development'
);

CREATE TYPE listing_type AS enum (
    'buy',
    'sell'
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

CREATE TABLE market_items (
    item_id     serial PRIMARY KEY REFERENCES items, 
    market_id   serial REFERENCES markets,
    name        varchar(31) NOT NULL,
    image_url   varchar(255) NOT NULL,
    popularity  integer NOT NULL DEFAULT 0 CHECK (popularity >= 0),
    quantity    integer NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    price       integer CHECK (price > 0),
    name_search tsvector generated always as (to_tsvector('english', name)) stored
);

CREATE TABLE users (
    user_id   serial PRIMARY KEY,
    name      varchar(31) NOT NULL,
    avatar_image_url varchar(255) NOT NULL
);

CREATE TABLE market_listings (
    item_instance_id serial PRIMARY KEY REFERENCES item_instances,
    item_id          serial REFERENCES items,
    market_id        serial REFERENCES markets,
    user_id          serial REFERENCES users,
    listing_type     listing_type NOT NULL,
    price            integer NOT NULL CHECK (price > 3),
    created_at       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE market_sales (
    sale_id          serial PRIMARY KEY,
    item_instance_id serial REFERENCES item_instances,
    item_id          serial REFERENCES items,
    market_id        serial REFERENCES markets,
    from_user_id     serial REFERENCES users,
    to_user_id       serial REFERENCES users,
    price            integer NOT NULL CHECK (price > 0),
    time             timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE waitlist (
    email      varchar(255) PRIMARY KEY,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);
