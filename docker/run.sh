#!/bin/sh

cat ../scripts/schema.sql ../scripts/ICs.sql ../scripts/populate.sql ../scripts/view.sql | _ docker-compose exec -T db psql postgres postgres
