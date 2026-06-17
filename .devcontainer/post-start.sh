#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for Docker daemon..."
for i in $(seq 1 60); do
  if docker info >/dev/null 2>&1; then
    break
  fi

  if [ "$i" -eq 60 ]; then
    echo "Docker daemon did not become ready" >&2
    exit 1
  fi

  sleep 1
done

echo "Starting minikube..."
minikube start --driver=docker

line='eval $(minikube docker-env)'
touch "$HOME/.bashrc"
grep -qxF "$line" "$HOME/.bashrc" || echo "$line" >> "$HOME/.bashrc"
