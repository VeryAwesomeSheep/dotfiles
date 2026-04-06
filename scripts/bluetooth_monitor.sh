#!/bin/bash

# Bluetooth D-Bus monitor.

# Notifier script
HANDLER="$HOME/.config/scripts/event_handler.sh"

# Filter dbus-monitor to ONLY show PropertiesChanged events for Bluetooth Devices
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.bluez.Device1'" | \
while read -r line; do

    # Catch the signal line
    if [[ "$line" =~ path=/org/bluez/hci.*/dev_([0-9A-Z_]+) ]]; then
        # Replace underscores with colons for bluetoothctl (AA:BB:CC:DD:EE:FF)
        MAC="${BASH_REMATCH[1]//_/:}"
    fi

    # Look for the 'Connected' property changing
    if [[ "$line" =~ string\ \"Connected\" ]]; then
        # Read the very next line to get the boolean value
        read -r val_line

        # Fetch device name
        DEVICE_NAME=$(bluetoothctl info "$MAC" | awk -F': ' '/Alias:/ {print $2; exit}')
        DEVICE_NAME="${DEVICE_NAME:-Unknown Device}"

        # Trigger notifier script
        if [[ "$val_line" =~ boolean\ true ]]; then
            "$HANDLER" bluetooth connected "$DEVICE_NAME"
        elif [[ "$val_line" =~ boolean\ false ]]; then
            "$HANDLER" bluetooth disconnected "$DEVICE_NAME"
        fi
    fi
done
