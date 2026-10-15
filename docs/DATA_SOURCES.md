# Input datasets

There are two categories of input: one real, large clickstream CSV and several smaller *synthetic* sources which have been generated and linked to selected clickstream users.

## A. Website events — Kaggle

**Source:** [eCommerce behavior data from multi category store](https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store), by Michael Kechinov (original event data: REES46 / Open CDP project).

Use the **`2019-Oct.csv`** file only. The source contains about **42.4 million events** (roughly **5.7 GB uncompressed**). You must ingest at least 5 million records, and may process the full month for extra credit. The file is intentionally **not stored in Git**.

Place the extracted file here:

```text
data/2019-Oct.csv
```

You can download from the Kaggle page or use the Kaggle CLI (authentication required):

```bash
mkdir -p data
kaggle datasets download \
  -d mkechinov/ecommerce-behavior-data-from-multi-category-store \
  -f 2019-Oct.csv -p ./data --unzip
```

Columns: `event_time`, `event_type` (`view`, `cart`, `remove_from_cart`, `purchase`), `product_id`, `category_id`, `category_code`, `brand`, `price`, `user_id`, `user_session`. Event timestamps are UTC. Some category and brand values are absent. Clickstream purchases are *events*, not confirmation of payment settlement.

**Important:** Customer/activity calculations will be limited to the portion of clickstream you ingest. If processing fewer than all October rows, describe the resulting coverage and limitations in your submission.

## B. Supplemental datasets — provided in `fixtures/`

The supplied supplemental files are **synthetic**. Their `web_user_id` values are related to the Kaggle source and some customers can be found across several sources. The files may contain deliberate duplicates, missing values and conflicting identifiers.

| File | Simulates | Key fields |
| --- | --- | --- |
| `crm_contacts.csv` | CRM source (loaded to PostgreSQL) | `contact_id`, `web_user_id`, `email`, `phone`, `updated_at` |
| `orders.csv` | Order management (loaded to PostgreSQL) | `order_id`, `contact_id`, `web_user_id`, `ordered_at`, `gross_amount`, `order_status` |
| `payments.csv` | Payment provider (loaded to PostgreSQL) | `payment_id`, `order_id`, `payment_status`, `payment_amount`, `updated_at` |
| `identity_links.jsonl` | Verified customer/website identifier associations | `link_id`, `contact_id`, `web_user_id`, `user_session`, `verified`, `verification_method` |
| `support_tickets.jsonl` | Customer support system | `ticket_id`, `contact_id`, `email`, `status`, `updated_at` |
| `campaign_events.csv` | Marketing activity | `campaign_event_id`, `contact_id`, `event_type`, `event_time`, `campaign_id` |
| `consent_changes.csv` | Marketing consent changes | `consent_id`, `contact_id`, `channel`, `consent_status`, `updated_at` |
| `manifest.json` | Dataset generation metadata | Source rows scanned, file row counts and generation details |

See [fixtures/README.md](../fixtures/README.md) for the full file schema. Do not assume that two people who share a phone number are the same customer; identity correctness matters.

## Reference date and currency

- Evaluate the requested customer segments relative to **2019-11-01 00:00:00 UTC**.
- Synthetic orders and payments use **USD**.
