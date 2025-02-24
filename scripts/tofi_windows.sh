#!/bin/bash

# Get info of all active windows in JSON format
windows=$(hyprctl -j clients)

# Extract data from JSONs
# Extract the 'address' value
mapfile -t addresses < <(echo "$windows" | jq -r '.[] | .address')

# Extract the 'workspace.id' value
mapfile -t workspaces < <(echo "$windows" | jq -r '.[] | .workspace.id?')

# Extract the 'title' value
mapfile -t titles < <(echo "$windows" | jq -r '.[] | .title')

# Prepare input list for tofi
tofi_options=""
for i in "${!addresses[@]}"; do
  tofi_options+="[${workspaces[$i]}] ${titles[$i]} (${addresses[$i]})"$'\n'
done

# Selected option
selection=$(echo "$tofi_options" | tofi --prompt-text "Windows: ")

# Check if something was selected
if [ -n "$selection" ]; then
  # Parse the address from selection
  selected_address=$(echo "$selection" | grep -oE '0x[a-fA-F0-9]{12,}')

  # Check if address was extracted
  if [ -n "$selected_address" ]; then
    # Execute hyprland dispatch
    sh -c "hyprctl dispatch focuswindow address:$selected_address"
  fi
fi
