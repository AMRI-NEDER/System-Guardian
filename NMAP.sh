#!/bin/bash

mkdir -p logs
LOGFILE="logs/network_scan_$(date +%Y%m%d_%H%M%S).log"

IP_CIDR=$(ip -4 addr show scope global | awk '/inet/ {print $2; exit}')

if [ -z "$IP_CIDR" ]; then
  echo "❌ No active IPv4 network found."
  exit 1
fi

echo "🔍 Scanning network: $IP_CIDR"
echo "Scan started at: $(date '+%Y-%m-%d %H:%M:%S')" > "$LOGFILE"

nmap -sn "$IP_CIDR" >> "$LOGFILE" 2>&1

ACTIVE_HOSTS=$(grep -c "Nmap scan report for" "$LOGFILE")

echo "" >> "$LOGFILE"
echo "📊 Summary:" >> "$LOGFILE"
echo "Active hosts found: $ACTIVE_HOSTS" >> "$LOGFILE"

echo "✅ Network scan completed."
echo "Active hosts: $ACTIVE_HOSTS"
echo "Log saved in: $LOGFILE"

cat "$LOGFILE"

