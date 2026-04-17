#!/usr/bin/env bash

DDC_BUS=11
DDC_DEV="--bus=$DDC_BUS"
THINSPACE=$'\xE2\x80\x86'

get_brightness_ddc() {
    ddcutil $DDC_DEV getvcp 10 2>/dev/null | sed -n 's/.*current value = *\([0-9]*\).*/\1/p'
}

get_brightness_sysfs() {
    local current=$(cat /sys/class/backlight/intel_backlight/brightness 2>/dev/null || echo 0)
    local max=$(cat /sys/class/backlight/intel_backlight/max_brightness 2>/dev/null || echo 1)
    [ "$max" -eq 0 ] && max=1
    echo $((current * 100 / max))
}

get_icon() {
    echo "%{T28}󰤄%{T-}"
}

get_bar() {
    local pct=$1
    local filled=$((pct * 7 / 100))
    [ $filled -gt 7 ] && filled=7
    local empty=$((7 - filled))
    bar=""
    for i in $(seq 1 $filled); do
        bar+="%{T19}%{F#3CDFFF}%{F-}%{T-} "
    done
    for i in $(seq 1 $empty); do
        bar+="%{T19}%{F#80666666}%{F-}%{T-} "
    done
    echo "$bar"
}

case "$1" in
    get)
        ddc_val=$(get_brightness_ddc)
        
        if [ -n "$ddc_val" ] && [ "$ddc_val" -gt 0 ] 2>/dev/null; then
            icon=$(get_icon "$ddc_val")
            bar=$(get_bar "$ddc_val")
            echo "%{F#E6E600}$icon%{F-}$THINSPACE$bar"
        else
            sysfs_val=$(get_brightness_sysfs)
            [ -z "$sysfs_val" ] && sysfs_val=0
            icon=$(get_icon "$sysfs_val")
            bar=$(get_bar "$sysfs_val")
            echo "%{F#E6E600}$icon%{F-}$THINSPACE$bar"
        fi
        ;;
# - inc/dec functions - Use calculated value instead of reading sysfs
    inc)
        current=$(cat /sys/class/backlight/intel_backlight/brightness 2>/dev/null || echo 0)
        max=$(cat /sys/class/backlight/intel_backlight/max_brightness 2>/dev/null || echo 100)
        [ "$max" -eq 0 ] && max=1
        newval=$((current + max * 5 / 100))
        [ $newval -gt $max ] && newval=$max
        brightnessctl -d intel_backlight set $newval 2>/dev/null
        ddcutil $DDC_DEV setvcp 10 $((newval * 100 / max)) 2>/dev/null
        sysfs_val=$((newval * 100 / max))
        icon=$(get_icon "$sysfs_val")
        bar=$(get_bar "$sysfs_val")
        echo "%{F#E6E600}$icon%{F-}$THINSPACE$bar"
        ;;
    dec)
        current=$(cat /sys/class/backlight/intel_backlight/brightness 2>/dev/null || echo 0)
        max=$(cat /sys/class/backlight/intel_backlight/max_brightness 2>/dev/null || echo 100)
        [ "$max" -eq 0 ] && max=1
        newval=$((current - max * 5 / 100))
        [ $newval -lt 1 ] && newval=1
        brightnessctl -d intel_backlight set $newval 2>/dev/null
        ddcutil $DDC_DEV setvcp 10 $((newval * 100 / max)) 2>/dev/null
        sysfs_val=$((newval * 100 / max))
        icon=$(get_icon "$sysfs_val")
        bar=$(get_bar "$sysfs_val")
        echo "%{F#E6E600}$icon%{F-}$THINSPACE$bar"
        ;;
    icon)
        ddc_val=$(get_brightness_ddc)
        if [ -n "$ddc_val" ] && [ "$ddc_val" -gt 0 ] 2>/dev/null; then
            icon=$(get_icon "$ddc_val")
            echo "%{F#E6E600}$icon%{F-}"
        else
            sysfs_val=$(get_brightness_sysfs)
            [ -z "$sysfs_val" ] && sysfs_val=0
            icon=$(get_icon "$sysfs_val")
            echo "%{F#E6E600}$icon%{F-}"
        fi
        ;;
# - watch function - Move sleep to beginning of loop:
    watch)
        last_val=""
        while true; do
            sleep 0.15
            sysfs_val=$(get_brightness_sysfs)
            [ -z "$sysfs_val" ] && sysfs_val=0
            if [ "$sysfs_val" != "$last_val" ]; then
                icon=$(get_icon "$sysfs_val")
                bar=$(get_bar "$sysfs_val")
                echo "%{F#E6E600}$icon%{F-}$THINSPACE$bar"
                last_val="$sysfs_val"
            fi
        done
        ;;
esac
