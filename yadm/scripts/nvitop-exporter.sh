#!/usr/bin/env bash

# Check if exporter is already running on port 5050
if curl -s --head http://localhost:5050 >/dev/null 2>&1; then
    echo "nvitop-exporter already running"
else
    echo "Starting nvitop-exporter..."
    nohup uvx nvitop-exporter --bind-address 0.0.0.0 --port 5050 \
        > /tmp/nvitop-exporter.log 2>&1 &
fi
