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

# - Added color overlay per percentage:

get_icon() {
    local pct=$1
    if [ "$pct" -le 10 ] 2>/dev/null; then
        echo "%{F#ff6633}%{T18}󰪞%{F-}%{T-}"
    elif [ "$pct" -le 25 ] 2>/dev/null; then
        echo "%{F#ff9933}%{T18}󰪟%{F-}%{T-}"
    elif [ "$pct" -le 40 ] 2>/dev/null; then
        echo "%{F#ff9933}%{T18}󰪠%{F-}%{T-}"
    elif [ "$pct" -le 55 ] 2>/dev/null; then
        echo "%{F#00aaff}%{T18}󰪡%{F-}%{T-}"
    elif [ "$pct" -le 70 ] 2>/dev/null; then
        echo "%{F#00aaff}%{T18}󰪢%{F-}%{T-}"
    elif [ "$pct" -le 85 ] 2>/dev/null; then
        echo "%{F#00aaff}%{T18}󰪣%{F-}%{T-}"
    elif [ "$pct" -lt 100 ] 2>/dev/null; then
        echo "%{F#00aaff}%{T18}󰪤%{F-}%{T-}"
    else
        echo "%{F#00ff00}%{T18}󰪥%{F-}%{T-}"
    fi
}

get_bar() {
    local pct=$1
    local filled=$((pct / 10))
    local empty=$((10 - filled))
    printf '%*s' "$filled" | sed 's/ /▓/g' | sed 's/.*/%{T16}&%{T-}/'
    printf '%*s' "$empty" | sed 's/ /░/g' | sed 's/.*/%{T16}&%{T-}/'
}

case "$1" in
    get)
        ddc_val=$(get_brightness_ddc)
        
        if [ -n "$ddc_val" ] && [ "$ddc_val" -gt 0 ] 2>/dev/null; then
            icon=$(get_icon "$ddc_val")
            bar=$(get_bar "$ddc_val")
            echo "$icon ${ddc_val}%$THINSPACE%{F#555555}$bar%{F-}"
        else
            sysfs_val=$(get_brightness_sysfs)
            [ -z "$sysfs_val" ] && sysfs_val=0
            icon=$(get_icon "$sysfs_val")
            bar=$(get_bar "$sysfs_val")
            echo "$icon ${sysfs_val}%$THINSPACE%{F#555555}$bar%{F-}"
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
        echo "$icon ${sysfs_val}%$THINSPACE%{F#555555}$bar%{F-}"
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
        echo "$icon ${sysfs_val}%$THINSPACE%{F#555555}$bar%{F-}"
        ;;
    icon)
        ddc_val=$(get_brightness_ddc)
        if [ -n "$ddc_val" ] && [ "$ddc_val" -gt 0 ] 2>/dev/null; then
            icon=$(get_icon "$ddc_val")
            echo "$icon"
        else
            sysfs_val=$(get_brightness_sysfs)
            [ -z "$sysfs_val" ] && sysfs_val=0
            icon=$(get_icon "$sysfs_val")
            echo "$icon"
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
                echo "$icon ${sysfs_val}%$THINSPACE%{F#555555}$bar%{F-}"
                last_val="$sysfs_val"
            fi
        done
        ;;
esac
