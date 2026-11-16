#!/usr/bin/env bash
set -Eeuo pipefail
docker exec rakazo-postgres-1 psql -U rakazo -d rakazo -c 'select email, name, "emailVerified" as verified, "createdAt" from "user" order by "createdAt" desc limit 5;'
