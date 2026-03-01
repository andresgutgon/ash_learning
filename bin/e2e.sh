#!/bin/bash

# Script to run Elixir feature tests with Playwright
set -e

# Load environment variables for test environment
if [ -f ".env.development" ]; then
  set -a
  source ".env.development"
  set +a
fi

# Default to running all feature tests
TEST_PATH=${1:-"test/ash_learning_web/features/"}

echo "🎭 Running Elixir feature tests with Playwright: $TEST_PATH"

# Check required services are running
echo "🔍 Checking required services..."
check_service() {
  local service=$1
  local container_name="ash_learning-${service}-1"

  if ! docker ps --filter "name=${container_name}" --filter "status=running" --format "{{.Names}}" | grep -q "${container_name}"; then
    echo "❌ Service '${service}' is not running!"
    echo "   Please start it with: docker-compose up -d ${service}"
    return 1
  fi
  echo "✅ Service '${service}' is running"
}

check_service "db" || exit 1
check_service "traefik" || exit 1
check_service "playwright" || exit 1

# Set up test database (only if needed)
echo "🗄️  Ensuring test database exists..."
MIX_ENV=test ./bin/dev ecto.create --quiet || true  # Create only if doesn't exist
MIX_ENV=test ./bin/dev ecto.migrate --quiet || true  # Migrate only if needed

# Compile with correct environment to avoid runtime/compile-time mismatch
echo "🔧 Ensuring clean compile with test environment..."
MIX_ENV=test ./bin/dev clean --quiet || true
MIX_ENV=test ./bin/dev compile

echo "🧪 Executing Elixir tests with ./bin/dev..."
MIX_ENV=test ./bin/dev test $TEST_PATH
