#!/bin/bash

mkdir -p logs
LOG="logs/dos_detected.log"

THRESHOLD=100

ATTACKER_IP=$(netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
CONNECTIONS=$(netstat -ntu | awk '{print $5}' | cut -d: -f1 | grep -c "$ATTACKER_IP")

echo "$(date) IP with most connections: $ATTACKER_IP ($CONNECTIONS connections)" >> "$LOG"

if [ "$CONNECTIONS" -gt "$THRESHOLD" ]; then
  echo "⚠️ Possible DoS attack detected from $ATTACKER_IP ($CONNECTIONS connections)!"
  echo "$(date) ⚠️ Possible DoS attack from $ATTACKER_IP ($CONNECTIONS connections)" >> "$LOG"
  ./alert.sh "⚠️ Possible DoS attack from $ATTACKER_IP ($CONNECTIONS connections)"
else
  echo "✅ No suspicious DoS activity detected."
fi
