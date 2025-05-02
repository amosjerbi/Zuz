#!/bin/sh
# HELP: Load RetroArch State
# ICON: open
# GRID: RetroArch

# Configuration for buttons
SELECT_BUTTON=6
L2_BUTTON=9

# Function to load state
load_state() {
  if [ -f "/opt/muos/extras/retroarch_hotkey_manager/direct_key_sender.sh" ]; then
    sh /opt/muos/extras/retroarch_hotkey_manager/direct_key_sender.sh load_state
  else
    echo "LOAD_STATE" | nc -u localhost 55355
  fi
  echo "State loaded"
}

# Check if we're being called directly (menu launch)
if [ "$1" != "monitor" ]; then
  # Direct call from menu - just load the state
  load_state
  exit 0
fi

# Setup monitoring for SELECT+L2 hotkey
EVTEST="/usr/bin/evtest"
INPUT_DEVICE="/dev/input/event0"  # Default controller input

# Try to find gamepad device
for device in /dev/input/event*; do
  if [ -c "$device" ]; then
    device_name=$($EVTEST --info "$device" 2>/dev/null | grep -i "name" | grep -i "gamepad")
    if [ -n "$device_name" ]; then
      INPUT_DEVICE="$device"
      break
    fi
  fi
done

# Monitor button presses
select_pressed=0
l2_pressed=0

# Start hotkey monitoring in background
$EVTEST --grab "$INPUT_DEVICE" | while read -r line; do
  # Check for SELECT button press/release
  if echo "$line" | grep -q "type 1 (EV_KEY), code $SELECT_BUTTON .*, value 1"; then
    select_pressed=1
  elif echo "$line" | grep -q "type 1 (EV_KEY), code $SELECT_BUTTON .*, value 0"; then
    select_pressed=0
  fi
  
  # Check for L2 button press/release
  if echo "$line" | grep -q "type 1 (EV_KEY), code $L2_BUTTON .*, value 1"; then
    l2_pressed=1
  elif echo "$line" | grep -q "type 1 (EV_KEY), code $L2_BUTTON .*, value 0"; then
    l2_pressed=0
  fi
  
  # If both buttons are pressed together, trigger load state
  if [ $select_pressed -eq 1 ] && [ $l2_pressed -eq 1 ]; then
    load_state
    # Prevent multiple triggers
    sleep 1
  fi
done
