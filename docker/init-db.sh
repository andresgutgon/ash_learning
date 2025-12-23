#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    SELECT 'CREATE DATABASE ash_learning_development'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ash_learning_development')\gexec

    SELECT 'CREATE DATABASE ash_learning_test'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ash_learning_test')\gexec

    SELECT 'CREATE DATABASE ash_learning_fake_production'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ash_learning_fake_production')\gexec
EOSQL

