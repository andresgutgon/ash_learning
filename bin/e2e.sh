#!/bin/bash

# Script to run Elixir feature tests with Playwright
set -e

# Default to running all feature tests
TEST_PATH=${1:-"test/ash_learning_web/features/"}

echo "🎭 Running Elixir feature tests with Playwright: $TEST_PATH"

# Start Playwright container (assumes dev services are already running)
echo "📦 Starting Playwright container..."
docker-compose up -d playwright

# Run the tests from the web container
echo "🧪 Executing Elixir tests..."
docker-compose exec -e MIX_ENV=test web mix test $TEST_PATH
