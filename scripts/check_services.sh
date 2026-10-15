#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo 'PostgreSQL:'
docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT current_database() AS db, version() AS server_version;"'

echo 'ClickHouse:'
docker compose exec -T clickhouse sh -c 'clickhouse-client --user "$CLICKHOUSE_USER" --password "$CLICKHOUSE_PASSWORD" --database "$CLICKHOUSE_DB" --query "SELECT currentDatabase() AS db, version() AS server_version"'

echo 'Container status:'
docker compose ps
