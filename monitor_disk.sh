#!/bin/bash

mkdir -p logs
LOG="logs/disk_usage.log"

USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//g')


if ! [[ "$USAGE" =~ ^[0-9]+$ ]]; then
  echo "wrong value"
  exit 1
fi


echo "$(date '+%Y-%m-%d %H:%M:%S') Disk usage: ${USAGE}%" >> "$LOG"


THRESHOLD=80
if [ "$USAGE" -ge "$THRESHOLD" ]; then
  ./alert.sh "⚠️ Disk almost full: ${USAGE}%"
  ./auto_action.sh "Disk"
fi


echo "💾 Disk usage: ${USAGE}%"

