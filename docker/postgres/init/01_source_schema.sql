-- Operational-source tables ONLY, not the candidate's ClickHouse warehouse.
-- Automatically runs when PostgreSQL's Docker volume is FIRST initialised.
-- For an existing volume, ./scripts/seed_postgres.sh also re-runs this file.

CREATE TABLE IF NOT EXISTS crm_contacts (
    contact_id text PRIMARY KEY,
    web_user_id text,
    first_name text,
    last_name text,
    email text,
    phone text,
    loyalty_tier text,
    created_at timestamptz,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS orders (
    order_id text PRIMARY KEY,
    contact_id text,
    web_user_id text,
    ordered_at timestamptz,
    order_status text,
    gross_amount numeric(14, 2),
    currency_code text,
    source_purchase_items integer,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id text PRIMARY KEY,
    order_id text REFERENCES orders(order_id),
    payment_status text,
    payment_amount numeric(14, 2),
    currency_code text,
    updated_at timestamptz
);
