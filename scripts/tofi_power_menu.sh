#!/bin/bash

# Can be customized to whatever is needed. <displayed text>#<command>
menu=$(cat <<EOF
Lock#pidof hyprlock || hyprlock
Suspend#systemctl suspend
Shutdown#systemctl poweroff
Restart#systemctl reboot
Logout#loginctl terminate-user $USER
EOF
)

# Options to display in tofi
tofi_options=$(echo "$menu" | cut -d '#' -f 1)

# Selected option
selection=$(echo "$tofi_options" | tofi --prompt-text "Power menu: ")

# Check if something was selected
if [ -n "$selection" ]; then
  # Find the corresponding command
  command=$(echo "$menu" | grep "^$selection#" | cut -d '#' -f 2)

  # Check if a command was found
  if [ -n "$command" ]; then
    # Execute the command
    sh -c "$command"
  else
    # Notify if command was not found
    notify-send -a "$0" "Error: No command found for '$selection'"
  fi
fi
