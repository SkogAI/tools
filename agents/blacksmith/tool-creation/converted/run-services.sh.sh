#!/bin/bash

# @describe Starts services in a byobu session with configurable ports/hosts
# @arg SESSION_NAME=skogai-services Optional name for the byobu session
# @arg DEFAULT_HOST=localhost Default host for services
# @arg GOOSE_HOST=DEFAULT_HOST Host for goose service
# @arg GOOSE_PORT=PORT+8080 Port for goose service
# @arg MEMORY_HOST=DEFAULT_HOST Host for memory service
# @arg MEMORY_PORT=PORT+1 Port for memory service
# @arg SERVER_HOST=DEFAULT_HOST Host for server service
# @arg SERVER_PORT=PORT+2 Port for server service
# @env DEBUG Set to enable debug output

main() {
  local SESSION_NAME="$argc_SESSION_NAME"
  local DEFAULT_HOST="$argc_DEFAULT_HOST"

  # Service configuration with defaults (using argc values when available)
  local GOOSE_HOST="${argc_GOOSE_HOST:-$DEFAULT_HOST}"
  local GOOSE_PORT="${argc_GOOSE_PORT:-${PORT:-8080}}"

  local MEMORY_HOST="${argc_MEMORY_HOST:-$DEFAULT_HOST}"
  local MEMORY_PORT="${argc_MEMORY_PORT:-$((${PORT:-8080} + 1))}"

  local SERVER_HOST="${argc_SERVER_HOST:-$DEFAULT_HOST}"
  local SERVER_PORT="${argc_SERVER_PORT:-$((${PORT:-8080} + 2))}"

  # Function to check if byobu is available
  check_byobu() {
    if ! command -v byobu >/dev/null 2>&1; then
      echo "Error: byobu is not installed or not in PATH"
      echo "Please install byobu: sudo apt install byobu"
      exit 1
    fi
  }

  # Function to start service in new window
  start_service() {
    local service_name="$1"
    local script_path="$2"
    local host="$3"
    local port="$4"

    echo "Starting $service_name on $host:$port"
    byobu new-window -t "$SESSION_NAME" -n "$service_name" "cd $(pwd) && HOST=$host PORT=$port $script_path"
  }

  # Main execution
  check_byobu

  echo "Starting services in byobu session: $SESSION_NAME"

  # Create new session or attach if exists
  if byobu has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session $SESSION_NAME already exists, creating new windows..."
  else
    echo "Creating new byobu session: $SESSION_NAME"
    byobu new-session -d -s "$SESSION_NAME" -n "main" "echo 'SkogAI Services - Main Control'; bash"
  fi

  # Start services
  start_service "goose" "./scripts/run-goose.sh" "$GOOSE_HOST" "$GOOSE_PORT"
  start_service "memory" "./scripts/run-skogai-memory.sh" "$MEMORY_HOST" "$MEMORY_PORT"
  start_service "server" "./scripts/run-server.sh" "$SERVER_HOST" "$SERVER_PORT"

  echo ""
  echo "Services started in byobu session: $SESSION_NAME"
  echo "Available windows:"
  echo "  - main: control window"
  echo "  - goose: $GOOSE_HOST:$GOOSE_PORT"
  echo "  - memory: $MEMORY_HOST:$MEMORY_PORT"
  echo "  - server: $SERVER_HOST:$SERVER_PORT"
  echo ""
  echo "To attach: byobu attach -t $SESSION_NAME"
  echo "To detach: Ctrl+A, D"
  echo "To list sessions: byobu list-sessions"

  # Attach to session
  byobu attach -t "$SESSION_NAME"
}

eval "$(argc --argc-eval "$0" "$@")"
