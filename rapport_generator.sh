#!/bin/bash

mkdir -p logs output
REPORT="output/report_$(date +%Y%m%d_%H%M%S).txt"

echo "System Report - $(date)" > "$REPORT"
for FILE in cpu_usage ram_usage disk_usage networj status alerts; do
echo "=== $FILE ===" >> "$REPORT"
tail -5 logs/${FILE}.log >> "$REPORT"
echo "" >> "$REPORT"
done

echo "REPORT Saved: $REPORT"
