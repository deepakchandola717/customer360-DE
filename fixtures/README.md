# Supplemental source fixtures

Expected files:

```text
fixtures/
├── README.md
├── crm_contacts.csv
├── orders.csv
├── payments.csv
├── identity_links.jsonl
├── support_tickets.jsonl
├── campaign_events.csv
├── consent_changes.csv
└── manifest.json
```

These seven source files plus the manifest are created outside this repo by the organiser. The CSVs have a header row. JSONL files contain **one JSON object per line**. Some rows have missing or overlapping identifiers, formatting variations and deliberate duplicate deliveries.

## File fields

| File | Columns / keys |
| --- | --- |
| `crm_contacts.csv` | `contact_id`, `web_user_id`, `first_name`, `last_name`, `email`, `phone`, `loyalty_tier`, `created_at`, `updated_at` |
| `orders.csv` | `order_id`, `contact_id`, `web_user_id`, `ordered_at`, `order_status`, `gross_amount`, `currency_code`, `source_purchase_items`, `updated_at` |
| `payments.csv` | `payment_id`, `order_id`, `payment_status`, `payment_amount`, `currency_code`, `updated_at` |
| `identity_links.jsonl` | `link_id`, `contact_id`, `web_user_id`, `user_session`, `verification_method`, `verified`, `linked_at` |
| `support_tickets.jsonl` | `ticket_id`, `email`, `contact_id`, `topic`, `status`, `updated_at` |
| `campaign_events.csv` | `campaign_event_id`, `contact_id`, `event_type`, `event_time`, `campaign_id` |
| `consent_changes.csv` | `consent_id`, `contact_id`, `channel`, `consent_status`, `updated_at` |

The generator’s `manifest.json` describes the particular fixture cohort and should be included unchanged.

**Important:** The PostgreSQL seeding script imports only `crm_contacts.csv`, `orders.csv` and `payments.csv`. The candidate must ingest all other source files and the event CSV independently. No records are loaded into ClickHouse by the repository’s setup scripts.
