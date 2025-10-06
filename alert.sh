#!/bin/bash

MESSAGE="$1"

echo "alert: $MESSAGE"

mkdir -p logs

echo "$(date) ALERT: $MESSAGE" >> logs/alerts.log
