#!/bin/sh

sql=$(cat ../scripts/schema.sql ../scripts/ICs.sql ../scripts/populate.sql ../scripts/view.sql)
echo "$sql" | docker-compose exec -T db psql postgres postgres
