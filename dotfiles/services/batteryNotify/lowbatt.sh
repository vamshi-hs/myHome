#!/bin/sh

# Monitors the remaining battery capacity on a Linux system, and
# sends a desktop notification if the remaining capacity falls below a
# certain threshold.


WARNING_THRESHOLD=13 # percent
ICON="/usr/share/icons/gnome/scalable/status/battery-low-symbolic.svg"

CHECK_INTERVAL=60
CAPACITY_REGEX="Battery 0: Discharging, (\d{1,3})%"


while true; do
    remaining_capacity=$(acpi -b | perl -e "<> =~ /$CAPACITY_REGEX/ && print \${1}")

    if [ ! -z $remaining_capacity ] && [ $remaining_capacity -le $WARNING_THRESHOLD ]; then
        notify-send --urgency=critical "Battery Critically Low" "This computer has about ${remaining_capacity}% battery capacity remaining." --icon="$ICON"
    fi

    sleep $CHECK_INTERVAL
done
