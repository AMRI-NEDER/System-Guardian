#!/bin/bash

mkdir -p logs
LOG="logs/network_status.log"

ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') Network: UP" >> "$LOG"
  STATUS="Network is UP"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') Network: DOWN" >> "$LOG"
  ./alert.sh "⚠️ Network is down"
  ./auto_action.sh "Network"
  STATUS="Network is DOWN"
fi

echo "$STATUS"
