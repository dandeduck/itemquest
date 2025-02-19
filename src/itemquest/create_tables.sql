DROP TABLE IF EXISTS   market_sales, market_listings, market_items, item_instances, items, waitlist, markets, users;

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
    market_id  serial NOT NULL REFERENCES markets,
    status     item_status NOT NULL DEFAULT 'unpublished',
    name       varchar(31) NOT NULL,
    image_url  varchar(255),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    user_id          uuid PRIMARY KEY,
    name             varchar(31) NOT NULL UNIQUE,
    avatar_image_url varchar(255) NOT NULL,
    email            varchar(255) NOT NULL UNIQUE,
    password_hash    bytea NOT NULL
);

CREATE TABLE item_instances (
    item_instance_id serial PRIMARY KEY, 
    item_id          serial NOT NULL REFERENCES items,
    user_id          uuid NOT NULL REFERENCES users,
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE market_items (
    item_id     serial PRIMARY KEY REFERENCES items, 
    market_id   serial NOT NULL REFERENCES markets,
    name        varchar(31) NOT NULL,
    image_url   varchar(255) NOT NULL,
    popularity  integer NOT NULL DEFAULT 0 CHECK (popularity >= 0),
    quantity    integer NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    price       integer CHECK (price > 0),
    name_search tsvector generated always as (to_tsvector('english', name)) stored
);

CREATE TABLE market_listings (
    item_instance_id serial PRIMARY KEY REFERENCES item_instances,
    item_id          serial NOT NULL REFERENCES items,
    market_id        serial NOT NULL REFERENCES markets,
    user_id          uuid NOT NULL REFERENCES users,
    listing_type     listing_type NOT NULL,
    price            integer NOT NULL CHECK (price > 3),
    created_at       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE market_sales (
    sale_id          serial PRIMARY KEY,
    item_instance_id serial NOT NULL REFERENCES item_instances,
    item_id          serial NOT NULL REFERENCES items,
    market_id        serial NOT NULL REFERENCES markets,
    from_user_id     uuid NOT NULL REFERENCES users,
    to_user_id       uuid NOT NULL REFERENCES users,
    price            integer NOT NULL CHECK (price > 0),
    time             timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE waitlist (
    email      varchar(255) PRIMARY KEY,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);
