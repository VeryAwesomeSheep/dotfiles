#!/bin/bash

# Master script for data fetching.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_with_retries() {
  local max_attempts=3
  local attempt=1
  local command=("$@")

  while [ $attempt -le $max_attempts ]; do
    if "${command[@]}"; then
      return 0 # Success
    else
      echo "Attempt $attempt failed for: ${command[*]}"
      sleep 2
      ((attempt++))
    fi
  done
  return 1 # Fail
}

# Check for internet connection
if ! ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
  echo "No internet connection. Exiting."
  exit 1
fi

# Execute fetchers
run_with_retries "$DIR/wttrin.sh" --fetch &
run_with_retries "$DIR/updates.sh" --fetch &

# Wait for jobs
wait
