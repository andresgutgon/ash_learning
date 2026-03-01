#!/bin/bash

# Script to run Elixir feature tests with Playwright
set -e

# Clean up function
cleanup() {
  echo "🧹 Cleaning up..."
  if [ ! -z "$SERVER_PID" ]; then
    kill $SERVER_PID 2>/dev/null || true
    wait $SERVER_PID 2>/dev/null || true
  fi
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Load environment variables for test environment
if [ -f ".env.development" ]; then
  set -a
  source ".env.development"
  set +a
fi

TEST_PATH=${1:-"test/ash_learning_web/features/"}

echo "🎭 Running Elixir feature tests with Playwright: $TEST_PATH"

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

echo "🗄️  Using test database..."
MIX_ENV=test ./bin/dev ecto.create --quiet || true
MIX_ENV=test ./bin/dev ecto.migrate --quiet || true

echo "🔧 Compiling with test environment..."
MIX_ENV=test ./bin/dev compile

echo "🧪 Starting Phoenix server for E2E tests..."

# Use test environment with Playwright WebSocket connection
export MIX_ENV=test
export PLAYWRIGHT_WS_ENDPOINT="ws://localhost:3000"

# Start Phoenix server with Vite watcher
echo "🚀 Starting Phoenix server with Vite..."
PHX_SERVER=true ./bin/dev phx.server &
SERVER_PID=$!

# Wait for the actual app to be responsive
echo "⏳ Waiting for app to be ready..."
for i in {1..60}; do
  if curl -k -s -o /dev/null https://app.ashlearning.dev/login; then
    echo "✅ App is ready!"
    break
  fi
  if [ $i -eq 60 ]; then
    echo "❌ App failed to be ready after 60 seconds"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
  fi
  sleep 2
done

# Now run tests against the running server (NO server for tests)
echo "🧪 Running E2E tests..."
MIX_ENV=test PHX_SERVER=false PLAYWRIGHT_WS_ENDPOINT="ws://localhost:3000" ./bin/dev test test/ash_learning_web/features/
TEST_EXIT_CODE=$?

# Clean up
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

echo "✅ E2E tests completed with exit code: $TEST_EXIT_CODE"
exit $TEST_EXIT_CODE
