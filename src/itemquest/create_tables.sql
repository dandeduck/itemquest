DROP TABLE IF EXISTS template_market_entries, items, item_templates;

CREATE TABLE item_templates (
    template_id serial PRIMARY KEY, 
    name varchar(32) NOT NULL
);

CREATE TABLE items (
    item_id serial PRIMARY KEY, 
    template_id serial REFERENCES item_templates
);

CREATE TABLE template_market_entries (
    template_id serial PRIMARY KEY REFERENCES item_templates, 
    quantity integer CHECK (quantity > 0),
    price integer CHECK (price > 0)
);
