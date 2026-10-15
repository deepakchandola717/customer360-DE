# Local setup

This repository supplies only the two databases and sample *source* tables. It intentionally does not include ClickHouse table definitions, ingestion jobs or segmentation logic.

## With Docker Compose

**Prerequisites:** Docker Engine/Desktop with Compose; enough free space for the large events CSV and database storage.

```bash
# Run from the repository root.
cp .env.example .env
# Put the seven supplied CSV/JSONL files and manifest.json in fixtures/.
# Download the event dataset to data/2019-Oct.csv (see DATA_SOURCES.md).
docker compose up -d
./scripts/check_services.sh
./scripts/seed_postgres.sh
```

`docker compose up -d` starts:

| Service | Container port | Default host address | DB | User / password |
| --- | --- | --- | --- | --- |
| PostgreSQL 16 | 5432 | localhost:5433 | `cdp_source` | `cdp` / `cdp_local_only` |
| ClickHouse 25.8 HTTP | 8123 | localhost:8123 | `customer360` | `cdp` / `cdp_local_only` |
| ClickHouse 25.8 native | 9000 | localhost:9000 | `customer360` | `cdp` / `cdp_local_only` |

Host ports and credentials can be changed in `.env` **before first initialisation**. Container-to-container connections use service names `postgres:5432` and `clickhouse:8123` / `clickhouse:9000` instead of `localhost`.

**What is set up?** PostgreSQL has `crm_contacts`, `orders`, `payments` tables (created automatically on the first clean start); the seed script imports the three corresponding CSV files. ClickHouse has only the initial `customer360` database and **no analytical tables or data**. Candidates build and run their own ClickHouse warehouse and ETL/ELT jobs. The remaining fixture files (`identity_links.jsonl`, `support_tickets.jsonl`, `campaign_events.csv`, `consent_changes.csv`) remain on disk for candidates to process.

**Seed script warning:** Running `./scripts/seed_postgres.sh` again deletes and reloads all records in the three PostgreSQL source tables. Do not re-run it after modifying source records to test incremental ingestion unless you want to restore the supplied state.

**Storage:** Named Docker volumes persist through `docker compose down`. `docker compose down -v` removes the local database data and is destructive.

## Without Docker

Set up equivalent local services:

1. PostgreSQL 16 (or compatible) with database `cdp_source` and credentials of your choice.
2. Execute `docker/postgres/init/01_source_schema.sql` in PostgreSQL.
3. Load `fixtures/crm_contacts.csv`, `fixtures/orders.csv`, `fixtures/payments.csv` into the matching source tables in that order. Adapt the three `\copy` commands in `docker/postgres/seed_source_data.sql` to paths on your machine.
4. ClickHouse 25.8 (or compatible), with an empty database named `customer360` and a user who can create tables and insert/query data.
5. Read the remaining local fixtures as input files, and build the ingestion/transformation pipeline yourself.

## Common problems

- Cannot connect to Docker daemon: launch Docker Desktop.
- Port already used: edit `POSTGRES_PORT`, `CLICKHOUSE_HTTP_PORT` or `CLICKHOUSE_NATIVE_PORT` in `.env`, then recreate containers.
- Fixtures missing: add files to `fixtures/`; only `fixtures/README.md` exists in the starter repository.
- Initial schema missing on existing volume: run `./scripts/seed_postgres.sh` or manually apply the SQL schema.
- Updated a database password in `.env` after data was initialised: changing environment values does not automatically update an existing persisted database user. Restore original credentials or manually update the user.
- Bad CSV formatting: verify fixture headers match `docs/DATA_SOURCES.md`.

This is an intentionally local-only configuration. Do not expose these database credentials or ports publicly.
