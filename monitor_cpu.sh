#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs
LOG="logs/cpu_usage.log"

# Get current CPU usage: 100 - idle CPU (%id from top)
CPU=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print 100 - $1}' || echo "0.0")

# Exit if CPU variable is empty
if [ -z "$CPU" ]; then
  echo "CPU usage not detected! Exiting."
  exit 1
fi

# Convert to integer (remove decimal part)
CPU_INT=${CPU%.*}

# Log CPU usage with timestamp
echo "$(date) CPU: $CPU%" >> "$LOG"
echo "Current CPU usage: $CPU%"

# Set CPU threshold
THRESHOLD=80

# Check if CPU usage is above threshold
if [ "$CPU_INT" -ge "$THRESHOLD" ]; then
  echo "High CPU usage detected: $CPU%"
  ./alert.sh "High CPU usage: $CPU%"
  ./auto_action.sh "CPU"
fi

