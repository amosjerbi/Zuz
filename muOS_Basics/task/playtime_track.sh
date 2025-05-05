#!/bin/sh
# HELP: Track Play Time
# ICON: track
# GRID: Tools

. /opt/muos/script/var/func.sh

# Save terminal settings
old_term=$(stty -g)

# Set initial terminal state
stty raw -echo

echo app >/tmp/act_go

# RG35XX Button Codes (in hexadecimal):
# Button Press: "0001 XXXX 0001"  Release: "0001 XXXX 0000"
#
# D-Pad:
# UP    = BTN_DPAD_UP    = 0x220 = 544
# DOWN  = BTN_DPAD_DOWN  = 0x221 = 545
# LEFT  = BTN_DPAD_LEFT  = 0x222 = 546
# RIGHT = BTN_DPAD_RIGHT = 0x223 = 547
#
# Face Buttons:
# A     = BTN_SOUTH = 0x130 = 304  (BTN_A)
# B     = BTN_EAST  = 0x131 = 305  (BTN_B)
# X     = BTN_NORTH = 0x133 = 307  (BTN_X)
# Y     = BTN_WEST  = 0x134 = 308  (BTN_Y)
#
# Shoulder Buttons:
# L1    = BTN_TL    = 0x136 = 310
# R1    = BTN_TR    = 0x137 = 311
# L2    = BTN_TL2   = 0x138 = 312  (BTN_SELECT)
# R2    = BTN_TR2   = 0x139 = 313  (BTN_START)

# Initialize variables
PLAYTIME_DATA_DIR="/mnt/mmc/muos/info/track"
PLAYTIME_DATA_FILE=$PLAYTIME_DATA_DIR/playtime_data.json
PID_FILE=/tmp/track_time.pid
DEBUG_LOG="/tmp/track_time_debug.log"
GPTOKEYB="$(GET_VAR "device" "storage/rom/mount")/MUOS/emulator/gptokeyb/gptokeyb2.armhf"

# Cleanup function
cleanup() {
    # Kill all child processes
    pkill -P $$ 2>/dev/null
    
    # Kill gptokeyb if running
    [ -n "$GPTOKEYB_PID" ] && kill $GPTOKEYB_PID 2>/dev/null
    
    # Kill input monitor if running
    [ -n "$INPUT_PID" ] && kill $INPUT_PID 2>/dev/null
    
    # Restore terminal settings
    stty $old_term 2>/dev/null
    printf '\033[?25h'  # Show cursor
    printf '\033c'      # Reset terminal
    tput reset         # Clear and reset terminal
    
    # Clean up files
    rm -f $PID_FILE $KEYMAP_FILE
    
    # Tell muOS we're done
    echo 0 > /tmp/safe_quit
    
    exit 0
}

# Set up traps for all possible exit scenarios
trap cleanup EXIT INT TERM HUP QUIT
#
# Special Buttons:
# SELECT = BTN_SELECT = 0x13a = 314
# START  = BTN_START  = 0x13b = 315
# MENU   = BTN_MODE   = 0x13c = 316
#
# Volume Buttons:
# VOL-  = KEY_VOLUMEDOWN = 0x72 = 114
# VOL+  = KEY_VOLUMEUP   = 0x73 = 115

# Create temporary keymap file
KEYMAP_FILE="/tmp/track_keymap.gptk"
cat > "$KEYMAP_FILE" << 'EOF'
back_hk = esc
select = KEY_SELECT
start = KEY_START
a = KEY_A
b = KEY_B
x = KEY_X
y = KEY_Y
l1 = KEY_L1
r1 = KEY_R1
EOF

# Start gptokeyb
$GPTOKEYB "track" -c "$KEYMAP_FILE" &
GPTOKEYB_PID=$!

# Set up environment
SET_VAR "system" "foreground_process" "track"

# Create PID file
echo $$ > $PID_FILE

# Initialize variables
CURRENT_PAGE=0
ITEMS_PER_PAGE=3
SELECT_PRESSED=0
START_PRESSED=0

# Clear screen function with proper terminal handling
clear_screen() {
    printf '\033[2J\033[H'  # Clear screen and move cursor to top-left
    tput reset 2>/dev/null || reset 2>/dev/null || clear
}

# Show game statistics
show_stats() {
    clear_screen
    if [ ! -f "$PLAYTIME_DATA_FILE" ]; then
        echo "Error: Data file not found"
        return
    fi
    
    if [ ! -s "$PLAYTIME_DATA_FILE" ]; then
        echo "Error: Data file is empty"
        return
    fi

    echo "Track Time Display"
    echo "Press R2 + L2 together to exit"
    echo "Use A/B buttons to navigate pages"
    echo "----------------------------------------"
    echo

    # Get total number of games
    TOTAL_GAMES=$(jq -r '[to_entries[] | select(.value.start_time != null)] | length' $PLAYTIME_DATA_FILE)
    TOTAL_PAGES=$(( (TOTAL_GAMES + ITEMS_PER_PAGE - 1) / ITEMS_PER_PAGE ))
    START_INDEX=$(( CURRENT_PAGE * ITEMS_PER_PAGE ))

    # Display page info
    echo "Page $(( CURRENT_PAGE + 1 ))/$TOTAL_PAGES"
    echo "----------------------------------------"
    echo

    # Display stats with proper format and pagination
    jq -r --argjson start "$START_INDEX" --argjson count "$ITEMS_PER_PAGE" '
        [to_entries[] | select(
            .value.start_time != null and
            .value.total_time != null and
            .value.avg_time != null and
            .value.last_session != null and
            .value.launches != null
        )] | .[$start:($start + $count)][] | 
        [
            .value.name,
            .value.start_time,
            .value.total_time,
            .value.avg_time,
            .value.last_session,
            .value.launches
        ] | @tsv
    ' $PLAYTIME_DATA_FILE | while IFS=$'\t' read -r name start_time total_time avg_time last_session launches; do
        echo "$name:"
        echo "  Start Time: $(format_timestamp "$start_time")"
        echo "  Total Time: $total_time minutes"
        echo "  Average Time: $(printf "%.0f" "$avg_time") minutes"
        echo "  Last Session: $last_session minutes"
        echo "  Total Sessions: $launches"
        echo
    done
}

# Format timestamp function
format_timestamp() {
    if echo "$1" | grep -q "^[0-9]*$"; then
        # It's a Unix timestamp
        date -d "@$1" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || date -j -f "%s" "$1" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "$1"
    else
        # It's already in ISO format, just clean it up
        echo "$1" | sed 's/T/ /;s/Z//'
    fi
}

# Initialize display
clear_screen
show_stats

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
            elif echo "$line" | grep -q "value 0"; then
                SELECT_PRESSED=0
            fi
        fi
        
        # START button
        if echo "$line" | grep -q "BTN_START"; then
            if echo "$line" | grep -q "value 1"; then
                START_PRESSED=1
            elif echo "$line" | grep -q "value 0"; then
                START_PRESSED=0
            fi
        fi
        
        # Check for SELECT + START combination
        if [ "$SELECT_PRESSED" -eq 1 ] && [ "$START_PRESSED" -eq 1 ]; then
            cleanup
        fi

        # A button (Previous page)
        if echo "$line" | grep -q "code 304.*value 1"; then
            if [ "$CURRENT_PAGE" -gt 0 ]; then
                CURRENT_PAGE=$((CURRENT_PAGE - 1))
                show_stats
            fi
        fi
        
        # B button (Next page)
        if echo "$line" | grep -q "code 305.*value 1"; then
            TOTAL_GAMES=$(jq -r '[to_entries[] | select(.value.start_time != null)] | length' $PLAYTIME_DATA_FILE)
            TOTAL_PAGES=$(( (TOTAL_GAMES + ITEMS_PER_PAGE - 1) / ITEMS_PER_PAGE ))
            if [ "$CURRENT_PAGE" -lt "$((TOTAL_PAGES - 1))" ]; then
                CURRENT_PAGE=$((CURRENT_PAGE + 1))
                show_stats
            fi
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

# Simple track time display script
PLAYTIME_DATA_DIR="/mnt/mmc/muos/info/track"
PLAYTIME_DATA_FILE=$PLAYTIME_DATA_DIR/playtime_data.json
PID_FILE=/tmp/track_time.pid
DEBUG_LOG="/tmp/track_time_debug.log"
GPTOKEYB="$(GET_VAR "device" "storage/rom/mount")/MUOS/emulator/gptokeyb/gptokeyb2.armhf"

# Create temporary keymap file
KEYMAP_FILE="/tmp/track_keymap.gptk"
cat > "$KEYMAP_FILE" << 'EOF'
back_hk = esc
select = KEY_SELECT
start = KEY_START
a = KEY_A
b = KEY_B
x = KEY_X
y = KEY_Y
l1 = KEY_L1
r1 = KEY_R1
EOF

# Start gptokeyb
$GPTOKEYB "track" -c "$KEYMAP_FILE" &
GPTOKEYB_PID=$!

# Set up environment
SET_VAR "system" "foreground_process" "track"

# Create PID file
echo $$ > $PID_FILE

# Initialize variables
CURRENT_PAGE=0
ITEMS_PER_PAGE=3
SELECT_PRESSED=0
START_PRESSED=0

# Cleanup function
cleanup() {
    echo "Cleanup triggered" >> $DEBUG_LOG
    
    # Tell muOS we're done
    echo 0 > /tmp/safe_quit
    
    # Kill gptokeyb
    kill $GPTOKEYB_PID 2>/dev/null || true
    
    # Reset terminal settings
    stty sane
    reset
    
    # Clean up files
    rm -f $PID_FILE
    rm -f $KEYMAP_FILE
    
    # Log exit
    echo "Script terminated" >> $DEBUG_LOG
    
    # Clear screen one last time before exiting
    clear
    
    exit 0
}

# Set up traps
trap cleanup INT TERM QUIT HUP EXIT

# Save original terminal settings
original_stty_settings=$(stty -g 2>/dev/null || echo "")

# Clear screen function
clear_screen() {
    tput reset || reset || clear
}

# Show game statistics
show_stats() {
    clear_screen
    if [ ! -f "$PLAYTIME_DATA_FILE" ]; then
        echo "Error: Data file not found"
        return
    fi
    
    if [ ! -s "$PLAYTIME_DATA_FILE" ]; then
        echo "Error: Data file is empty"
        return
    fi

    echo "Track Time Display"
    echo "Press R2 + L2 together to exit"
    echo "Use A/B buttons to navigate pages"
    echo "----------------------------------------"
    echo

    # Get total number of games
    TOTAL_GAMES=$(jq -r '[to_entries[] | select(.value.start_time != null)] | length' $PLAYTIME_DATA_FILE)
    TOTAL_PAGES=$(( (TOTAL_GAMES + ITEMS_PER_PAGE - 1) / ITEMS_PER_PAGE ))
    START_INDEX=$(( CURRENT_PAGE * ITEMS_PER_PAGE ))

    # Display page info
    echo "Page $(( CURRENT_PAGE + 1 ))/$TOTAL_PAGES"
    echo "----------------------------------------"
    echo

    # Display stats with proper format and pagination
    jq -r --argjson start "$START_INDEX" --argjson count "$ITEMS_PER_PAGE" '
        [to_entries[] | select(
            .value.start_time != null and
            .value.total_time != null and
            .value.avg_time != null and
            .value.last_session != null and
            .value.launches != null
        )] | .[$start:($start + $count)][] | 
        [
            .value.name,
            .value.start_time,
            .value.total_time,
            .value.avg_time,
            .value.last_session,
            .value.launches
        ] | @tsv
    ' $PLAYTIME_DATA_FILE | while IFS=$'\t' read -r name start_time total_time avg_time last_session launches; do
        echo "$name:"
        echo "  Start Time: $(format_timestamp "$start_time")"
        echo "  Total Time: $total_time minutes"
        echo "  Average Time: $(printf "%.0f" "$avg_time") minutes"
        echo "  Last Session: $last_session minutes"
        echo "  Total Sessions: $launches"
        echo
    done
}

# Format timestamp function
format_timestamp() {
    if echo "$1" | grep -q "^[0-9]*$"; then
        # It's a Unix timestamp
        date -d "@$1" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || date -j -f "%s" "$1" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "$1"
    else
        # It's already in ISO format, just clean it up
        echo "$1" | sed 's/T/ /;s/Z//'
    fi
}

# Initialize display
clear_screen

# Ensure terminal is in a good state
stty sane

show_stats

# Main input loop using evtest for the muOS-Keys device
(
    evtest /dev/input/event1 2>> $DEBUG_LOG | while read -r line; do
        echo "Event: $line" >> $DEBUG_LOG
        
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

        # A button (Previous page)
        if echo "$line" | grep -q "code 304.*value 1"; then
            echo "A button press detected" >> $DEBUG_LOG
            if [ "$CURRENT_PAGE" -gt 0 ]; then
                echo "Moving to previous page" >> $DEBUG_LOG
                CURRENT_PAGE=$((CURRENT_PAGE - 1))
                show_stats
            else
                echo "Already at first page" >> $DEBUG_LOG
            fi
        fi
        
        # B button (Next page)
        if echo "$line" | grep -q "code 305.*value 1"; then
            echo "B button press detected" >> $DEBUG_LOG
            TOTAL_GAMES=$(jq -r '[to_entries[] | select(.value.start_time != null)] | length' $PLAYTIME_DATA_FILE)
            TOTAL_PAGES=$(( (TOTAL_GAMES + ITEMS_PER_PAGE - 1) / ITEMS_PER_PAGE ))
            if [ "$CURRENT_PAGE" -lt "$((TOTAL_PAGES - 1))" ]; then
                echo "Moving to next page" >> $DEBUG_LOG
                CURRENT_PAGE=$((CURRENT_PAGE + 1))
                show_stats
            else
                echo "Already at last page" >> $DEBUG_LOG
            fi
        fi
    done
) &

INPUT_PID=$!

# Keep script running but allow for clean exit
while true; do
    if ! kill -0 $INPUT_PID 2>/dev/null; then
        echo "Input monitor died, exiting..." >> $DEBUG_LOG
        cleanup
    fi
    sleep 1
done 
