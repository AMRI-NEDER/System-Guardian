#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 <CPU | RAM | Disk | Network>"
  exit 1
fi

COMP="$1"
mkdir -p logs
LOG="logs/auto_actions.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') Auto-action triggered for: $COMP" >> "$LOG"

case "$COMP" in

  CPU)
    echo "Trying to fix CPU usage..."
    SELF_PID=$$
    PARENT_PID=$PPID

    TOP_INFO=$(ps -eo pid,comm,%cpu --sort=-%cpu | awk 'NR==2')
    PID=$(echo "$TOP_INFO" | awk '{print $1}')
    CMD=$(echo "$TOP_INFO" | awk '{print $2}')
    CPU=$(echo "$TOP_INFO" | awk '{print $3}')

    SAFE_LIST=("acceuil.sh" "auto_action.sh" "monitor_ram.sh" "monitor_network.sh" \
               "detect_dos.sh" "view_logs.sh" "detect_rogue.sh" "nmap_scan.sh" \
               "bash" "sh" "zsh" "gnome-terminal" "gnome-terminal-server" \
               "konsole" "xfce4-terminal" "xterm" "systemd" "Xorg" "login" \
               "tty" "init" "lightdm" "sysguard")

    for SAFE in "${SAFE_LIST[@]}"; do
      if [[ "$CMD" == *"$SAFE"* ]]; then
        echo "⚠️ Top process ($CMD) is protected. No action taken."
        echo "$(date '+%Y-%m-%d %H:%M:%S') ⚠️ Skipped protected process: $CMD (PID $PID)" >> "$LOG"
        ./alert.sh "Auto-action: skipped protected process ($CMD)"
        exit 0
      fi
    done
    echo "Killing process with PID: $PID"
    kill -9 "$PID" 2>/dev/null
    if [ $? -eq 0 ]; then
      echo "❌ Killed high-CPU process: $CMD (PID $PID, CPU ${CPU}%)"
      echo "$(date '+%Y-%m-%d %H:%M:%S') ❌ Killed process: $CMD (PID $PID, CPU ${CPU}%)" >> "$LOG"
      ./alert.sh "Auto-action: killed high CPU process (PID: $PID)"
    else
      echo "⚠️ Failed to kill $CMD (PID $PID)"
      echo "$(date '+%Y-%m-%d %H:%M:%S') ⚠️ Failed to kill: $CMD (PID $PID)" >> "$LOG"
      ./alert.sh "Auto-action: failed to kill high CPU process ($CMD)"
    fi
    ;;

  RAM)
    echo "Clearing RAM cache..."
    sync
    echo 3 > /proc/sys/vm/drop_caches
    echo "$(date '+%Y-%m-%d %H:%M:%S') ✅ Cleared RAM caches." >> "$LOG"
    ./alert.sh "Auto-action: cleared RAM caches"
    ;;

  Disk)
    echo "Deleting old temp files in /tmp..."
    find /tmp -type f -mtime +7 -exec rm -f {} \;
    echo "$(date '+%Y-%m-%d %H:%M:%S') 🗑️ Deleted old temp files in /tmp." >> "$LOG"
    ./alert.sh "Auto-action: deleted old temp files"
    ;;

  Network)
    echo "Restarting network service..."
    if command -v systemctl >/dev/null 2>&1; then
      systemctl restart NetworkManager.service 2>/dev/null || systemctl restart networking.service 2>/dev/null
    else
      service networking restart 2>/dev/null
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') 🔄 Restarted network service." >> "$LOG"
    ./alert.sh "Auto-action: restarted network service"
    ;;

  *)
    echo "Unknown component: $COMP"
    echo "$(date '+%Y-%m-%d %H:%M:%S') ❓ Unknown component in auto_action: $COMP" >> "$LOG"
    ./alert.sh "Auto-action: unknown component ($COMP)"
    ;;
esac

