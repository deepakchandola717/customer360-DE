-- This seeds PostgreSQL SOURCE tables from the supplied fixture files.
-- psql client is executed inside the postgres container, so /fixtures/... resolves
-- to the read-only bind mount in docker-compose.yml.
-- Deliberately reset on each run, to give candidates reproducible source inputs.
-- WARNING: This overwrites edits to the source tables made after the previous seed.

BEGIN;
TRUNCATE TABLE payments, orders, crm_contacts;
\copy crm_contacts (contact_id,web_user_id,first_name,last_name,email,phone,loyalty_tier,created_at,updated_at) FROM '/fixtures/crm_contacts.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy orders (order_id,contact_id,web_user_id,ordered_at,order_status,gross_amount,currency_code,source_purchase_items,updated_at) FROM '/fixtures/orders.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy payments (payment_id,order_id,payment_status,payment_amount,currency_code,updated_at) FROM '/fixtures/payments.csv' WITH (FORMAT csv, HEADER true, NULL '');
COMMIT;

SELECT 'crm_contacts' AS source, count(*) AS rows_loaded FROM crm_contacts
UNION ALL SELECT 'orders', count(*) FROM orders
UNION ALL SELECT 'payments', count(*) FROM payments
ORDER BY source;
