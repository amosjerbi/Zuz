#!/bin/sh
# HELP: Battery Info
# ICON: battery
# GRID: System

# Source muOS functions
. /opt/muos/script/var/func.sh

# Initialize variables
SELECT_PRESSED=0
START_PRESSED=0
DEBUG_LOG="/tmp/battery_info_debug.log"

# Cleanup function
cleanup() {
    # Kill all child processes
    pkill -P $$ 2>/dev/null
    
    # Restore terminal settings
    stty sane
    printf '\033[?25h'  # Show cursor
    printf '\033c'      # Reset terminal
    tput reset         # Clear and reset terminal
    
    # Tell muOS we're done
    echo 0 > /tmp/safe_quit
    
    exit 0
}

# Set up traps
trap cleanup INT TERM QUIT HUP EXIT

# Get battery info
BATTERY_PCT=$(cat /sys/class/power_supply/*/capacity 2>/dev/null)
BATTERY_INFO=$(cat /tmp/battery_status 2>/dev/null)

# Display battery info
clear
echo "Battery Status"
echo "-------------"
echo
echo "Current Level: $BATTERY_PCT%"
echo "Time Remaining: $BATTERY_INFO"
echo
echo "Press SELECT + START together to exit"

# Main input loop using evtest for the muOS-Keys device
(
    evtest /dev/input/event1 2>> $DEBUG_LOG | while read -r line; do
        # Log all button events for debugging
        if echo "$line" | grep -q "type 1 (EV_KEY)"; then
            echo "Button event: $line" >> $DEBUG_LOG
        fi

        # SELECT button
        if echo "$line" | grep -q "BTN_SELECT"; then
            if echo "$line" | grep -q "value 1"; then
                SELECT_PRESSED=1
                echo "SELECT pressed" >> $DEBUG_LOG
            elif echo "$line" | grep -q "value 0"; then
                SELECT_PRESSED=0
                echo "SELECT released" >> $DEBUG_LOG
            fi
        fi
        
        # START button
        if echo "$line" | grep -q "BTN_START"; then
            if echo "$line" | grep -q "value 1"; then
                START_PRESSED=1
                echo "START pressed" >> $DEBUG_LOG
            elif echo "$line" | grep -q "value 0"; then
                START_PRESSED=0
                echo "START released" >> $DEBUG_LOG
            fi
        fi
        
        # Check for SELECT + START combination
        if [ "$SELECT_PRESSED" -eq 1 ] && [ "$START_PRESSED" -eq 1 ]; then
            echo "SELECT + START combination detected, exiting..." >> $DEBUG_LOG
            cleanup
        fi
    done
) &

INPUT_PID=$!

# Keep script running but allow for clean exit
while true; do
    if ! kill -0 $INPUT_PID 2>/dev/null; then
        cleanup
    fi
    sleep 1
done