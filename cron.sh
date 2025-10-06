#!/bin/bash
# سكربت لإعداد Cron Jobs لتشغيل System Guardian تلقائياً

# مسار مجلد System Guardian
SG_PATH="/home/user/system-guardian"  # غيّر المسار حسب مكان مشروعك

# تحقق من وجود مجلد logs
mkdir -p "$SG_PATH/logs"

# تحرير جدول Cron للمستخدم الحالي
(crontab -l 2>/dev/null; echo "*/5 * * * * $SG_PATH/monitor_cpu.sh >> $SG_PATH/logs/cpu_cron.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/5 * * * * $SG_PATH/monitor_ram.sh >> $SG_PATH/logs/ram_cron.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 * * * * $SG_PATH/monitor_disk.sh >> $SG_PATH/logs/disk_cron.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/10 * * * * $SG_PATH/monitor_network.sh >> $SG_PATH/logs/network_cron.log 2>&1") | crontab -

echo "✅ Cron jobs added successfully!"
crontab -l
