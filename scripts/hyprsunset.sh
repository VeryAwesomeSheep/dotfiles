#!/bin/bash

# hyprsunset controlled by time of day
# hyprsunset v0.2 and hyprland 0.45 required

# Desired temperature
temperature=3500

# Hour at which hyprsunset should turn on and off
turn_on_hour=21
turn_off_hour=6

# Check current hour
current_hour=$(date +%H)

# Compare switch hours to current hour
if [[ "$current_hour" -ge "$turn_on_hour" || "$current_hour" -lt "$turn_off_hour" ]]; then
  # Time to turn on night light
  echo "Turning on night light"
  hyprctl hyprsunset temperature $temperature
else
  # Time to turn off night light
  echo "Turning off night light"
  hyprctl hyprsunset identity
fi

