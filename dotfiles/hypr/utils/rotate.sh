#!/usr/bin/env bash

MONITOR="eDP-1"
TOUCH_DEVICE="elan2513:00-04f3:406e"

# 0 = normal | 1 = 90° CW | 2 = 180° | 3 = 270° CW

apply_transform() {
    local transform=$1
    # Screen
    hyprctl keyword monitor "eDP-1,preferred,auto,1,transform,$transform" > /dev/null
    # Touchscreen
    hyprctl keyword input:touchdevice:transform "$transform" > /dev/null
    # Stylus/Pen
    hyprctl keyword "device[elan2513:00-04f3:406e-stylus]:transform" "$transform" > /dev/null
}

monitor-sensor | while IFS= read -r line; do
    if [[ "$line" == *"Accelerometer orientation changed"* ]]; then
        orientation="${line##*: }"
        orientation="${orientation//[[:space:]]/}"

        case "$orientation" in
            normal)
                apply_transform 0
                ;;
            right-up)
                apply_transform 3
                ;;
            bottom-up)
                apply_transform 2
                ;;
            left-up)
                apply_transform 1
                ;;
        esac
    fi
done
