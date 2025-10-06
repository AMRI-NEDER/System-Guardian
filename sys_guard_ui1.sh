#!/bin/bash

while true; do
  MAIN=$(dialog --clear --stdout --title "System Guardian 🛡️" --menu "Select a Category:" 15 60 6 \
    1 "Monitoring Tools" \
    2 "Network Tools" \
    3 "Security Tools" \
    4 "Exit")

  if [ $? -ne 0 ]; then clear; exit 0; fi

  case $MAIN in
    1)
      # Monitoring Sub-Menu
      MONITOR=$(dialog --stdout --title "Monitoring Tools" --menu "Choose:" 15 60 4 \
        1 "Monitor CPU" \
        2 "Monitor RAM" \
        3 "Monitor Disk" \
        4 "Back")
      case $MONITOR in
        1) OUTPUT=$(./monitor_cpu.sh); dialog --msgbox "$OUTPUT" 20 60 ;;
        2) OUTPUT=$(./monitor_ram.sh); dialog --msgbox "$OUTPUT" 20 60 ;;
        3) OUTPUT=$(./monitor_disk.sh); dialog --textbox output_disk.txt 20 60 ;;
        *) ;;
      esac
      ;;
    2)
      # Network Sub-Menu
      NET=$(dialog --stdout --title "Network Tools" --menu "Choose:" 15 60 5 \
        1 "Monitor Network" \
        2 "Detect Rogue Devices" \
        3 "Network Scan (Nmap)" \
        4 "SNMP Monitor" \
        5 "Back")
      case $NET in
        1) ./monitor_network.sh > output_network.txt; dialog --textbox output_network.txt 20 60 ;;
        2) ./rogue_device_detector.sh > output_rogue.txt; dialog --textbox output_rogue.txt 20 60 ;;
        3) ./nmap.sh > output_nmap.txt; dialog --textbox output_nmap.txt 20 60 ;;
        4) ./snmp.sh > output_snmp.txt; dialog --textbox output_snmp.txt 20 60 ;;
        *) ;;
      esac
      ;;
    3)
      # Security Sub-Menu
      SEC=$(dialog --stdout --title "Security Tools" --menu "Choose:" 15 60 4 \
        1 "Auto Action" \
        2 "Detect DoS Attack (TODO)" \
        3 "Back")
      case $SEC in
        1)
          COMP=$(dialog --stdout --title "Auto Action" --menu "Component:" 15 60 4 \
            CPU "Fix CPU" RAM "Fix RAM" Disk "Fix Disk" Network "Fix Network")
          [ -n "$COMP" ] && sudo ./auto_action.sh "$COMP" > output_auto.txt && dialog --textbox output_auto.txt 20 60
          ;;
        2)
          ./detect_dos.sh > output_dos.txt; dialog --textbox output_dos.txt 20 60
          ;;
        *) ;;
      esac
      ;;
    4) clear; exit 0 ;;
  esac
done
