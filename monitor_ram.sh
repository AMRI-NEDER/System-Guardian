#!/bin/bash

mkdir -p logs
LOG="logs/ram_usage.log"

RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')

RAM_USAGE=$(awk "BEGIN {printf \"%.1f\", ($RAM_USED/$RAM_TOTAL)*100}")


if [ -z "$RAM_USAGE" ]; then
  echo "RAM_USAGE is empty!"
  exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') RAM_USAGE: $RAM_USAGE%" >> "$LOG"

echo "🧠 RAM usage: $RAM_USAGE%"

THRESHOLD=80

RAM_INT=${RAM_USAGE%.*}

if [ "$RAM_INT" -ge "$THRESHOLD" ]; then
  ./alert.sh "⚠️ RAM high usage: $RAM_USAGE%"
  ./auto_action.sh "RAM"
fi

