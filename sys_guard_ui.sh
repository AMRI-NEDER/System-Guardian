  
#!/bin/bash

while true; do
  OPTION=$(dialog --clear --stdout --title "System Guardian v1.0" --menu "Select an option:" 20 60 8 \
    1 "Monitor CPU" \
    2 "Monitor RAM" \
    3 "Monitor Disk" \
    4 "Monitor Network" \
    5 "Auto Action" \
    6 "Detect Rogue Devices" \
    7 "Detect Dos Attack" \
    8 "Network Scan" \
    9 "EXIT")

  if [ $? -ne 0 ] || [ -z "$OPTION" ]; then
    clear
    exit 0
  fi

  case $OPTION in
    1)
      OUTPUT=$(./monitor_cpu.sh 2>&1)
      dialog --title "CPU Monitor Result" --msgbox "$OUTPUT" 20 60
      ;;
    2)
      OUTPUT=$(./monitor_ram.sh 2>&1)
      dialog --title "RAM Monitor Result" --msgbox "$OUTPUT" 20 60
      ;;
    3)
      ./monitor_disk.sh > output_disk.txt 2>&1
      dialog --title "Disk Monitor Result" --textbox output_disk.txt 20 60
      ;;
    4)
      ./monitor_network.sh > output_network.txt 2>&1
      dialog --title "Network Monitor Result" --textbox output_network.txt 20 60
      ;;
    5)
      COMPONENT=$(dialog --stdout --title "Auto Action" --menu "Select Component:" 15 60 4 \
        CPU "Fix CPU" \
        RAM "Fix RAM" \
        Disk "Fix Disk" \
        Network "Fix Network")

      if [ $? -eq 0 ] && [ -n "$COMPONENT" ]; then
        sudo ./auto_action.sh "$COMPONENT" > output_auto.txt 2>&1
        dialog --title "Auto Action Result" --textbox output_auto.txt 20 60
      fi
      ;;
    6)
      ./rogue_device_detector.sh > output_rogue.txt 2>&1
      dialog --title "Rogue Devices" --textbox output_rogue.txt 20 60
      ;;
    7)
      ./detect_dos.sh > output_detect_dos.txt 2>&1
      dialog --title "Detect Dos" --textbox output_detect_dos.txt 20 60
      ;; 
    8)
      ./NMAP.sh > output_nmap.txt 2>&1
      dialog --title "Network Scan Result" --textbox output_nmap.txt 20 60
      ;;
    9)
      clear
      exit 0
      ;;
    *)
      dialog --msgbox "Invalid option!" 6 30
      ;;
  esac
done
