#!/usr/bin/env bash

cat ./delete-tables.sh | docker exec -i broad_mysql bash
