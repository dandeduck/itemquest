DROP TABLE IF EXISTS template_market_entries, items, templates;
DROP TYPE IF EXISTS template_status;

CREATE TYPE template_status AS enum (
    'published',
    'unpublished'
);

CREATE TABLE templates (
    template_id serial PRIMARY KEY, 
    status template_status NOT NULL DEFAULT 'unpublished',
    name varchar(32) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE items (
    item_id serial PRIMARY KEY, 
    template_id serial REFERENCES templates,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE template_market_entries (
    template_id serial PRIMARY KEY REFERENCES templates, 
    quantity integer NOT NULL DEFAULT 0 CHECK (quantity > 0),
    price integer CHECK (price > 0)
);
