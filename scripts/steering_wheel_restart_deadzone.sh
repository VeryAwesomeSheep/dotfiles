#!/bin/bash

# Some games seems to have a big deadzone in the center when playing with a wheel (ex. ETS2)
# Resetting the deadzone fixes this issue
# Run this script with launch options for ex. in Steam
# "$HOME/.config/scripts/steering_wheel_restart_deadzone.sh ; %command%"

# Get the name of the device 
# Might need some grep if more than 1 controller is connected, not tested
wheel=$(evdev-joystick --l)

# Set deadzone to 0
evdev-joystick --evdev $wheel --d 0

# Notify
notify-send "Steering wheel deadzone has been reset"
