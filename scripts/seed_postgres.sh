#!/usr/bin/env bash
# Provision and (re)seed only the operational PostgreSQL source.
# This is assessment setup; it is NOT a data pipeline and does not touch ClickHouse.
set -euo pipefail
cd "$(dirname "$0")/.."

for file in crm_contacts.csv orders.csv payments.csv; do
  if [[ ! -f "fixtures/$file" ]]; then
    printf 'Missing fixtures/%s. Add the supplied source fixtures first.\n' "$file" >&2
    exit 1
  fi
done

if ! command -v docker >/dev/null 2>&1; then
  echo 'Docker is required for this script. See docs/SETUP.md for manual setup.' >&2
  exit 1
fi

# Idempotently create schema even if a prior volume was initialised without it.
docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/01_source_schema.sql'

# Loads all three CSVs in one psql transaction; a failed load rolls back the reset.
docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /setup/seed_source_data.sql'

echo 'PostgreSQL source tables seeded. ClickHouse remains the candidate’s responsibility.'
