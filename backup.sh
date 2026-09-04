#!/bin/bash

# Script that backups configs (ie. copies from .config etc to dotfiles repo)
# Verbose logging can be toggled via --verbose/-v flag

# Configuration
SOURCE_DIR="$HOME/.config"
DEST_DIR="."

ITEMS=(
  "clipse/config.json"
  "Code - OSS/User/settings.json"
  "dunst"
  "hypr"
  "icons"
  "kitty/kitty.conf" # change to full dir when theme ready
  "mpd/mpd.conf"
  "mpDris2"
  #"ncmpcpp" not finished
  "nvim"
  "scripts"
  "swappy"
  "systemd/user/bluetooth_monitor.service"
  "systemd/user/fetch_data.service"
  "systemd/user/fetch_data.timer"
  "systemd/user/hyprsunset.service"
  "systemd/user/hyprsunset.timer"
  "tofi"
  "waybar"
  "xdg-desktop-portal"
  "xdg-desktop-portal-termfilechooser"
  "yazi/init.lua"
  "yazi/keymap.toml"
  "yazi/package.toml"
  "yazi/yazi.toml"
  "zed/keymap.json"
  "zed/settings.json"
)

# Verbose logging
VERBOSE=false

log_verbose() {
  if [ "$VERBOSE" = true ]; then
    echo "$@"
  fi
}

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -v|--verbose) VERBOSE=true; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
done


# Ensure the source base directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "ERROR: Source directory '$SOURCE_DIR' not found"
  exit 1
fi

# Start copying
log_verbose "Starting backup..."
log_verbose "Source directory: $SOURCE_DIR"
log_verbose "Destination directory: $DEST_DIR (current directory)"
log_verbose "-------------------------------------"

copied_count=0
error_count=0

for item in "${ITEMS[@]}"; do
  source_item="$SOURCE_DIR/$item"
  dest_item="$DEST_DIR/$item"

  log_verbose "Processing: $item"

  # Check if the source item exists
  if [ ! -e "$source_item" ]; then
    echo "  ERROR: Source '$source_item' not found"
    ((error_count++))
    continue
  fi

  # Ensure the parent directory for the destination item exists
  dest_parent_dir=$(dirname "$dest_item")
  if [ ! -d "$dest_parent_dir" ]; then
    log_verbose "  Creating parent directory: '$dest_parent_dir'"
    mkdir -p "$dest_parent_dir"
    if [ $? -ne 0 ]; then
      echo "  ERROR: Failed to create parent directory '$dest_parent_dir'. Skipping item '$item'"
      ((error_count++))
      continue
    fi
  fi

  # If it's a directory, copy it recursively
  if [ -d "$source_item" ]; then
    log_verbose "  Copying directory: '$source_item' to '$dest_item/'"

    # Remove existing destination directory
    if [ -d "$dest_item" ]; then
      log_verbose "  Destination '$dest_item' already exists. Removing before copy."
      rm -rf "$dest_item"
      if [ $? -ne 0 ]; then
        echo "  ERROR: Failed to remove existing destination directory '$dest_item'"
        ((error_count++))
        continue
      fi
    fi

    cp -r "$source_item" "$dest_item"
    if [ $? -eq 0 ]; then
      log_verbose "  Successfully copied directory."
      ((copied_count++))
    else
      echo "  ERROR: Failed to copy directory '$source_item'"
      ((error_count++))
    fi

  # If it's a file, copy it
  elif [ -f "$source_item" ]; then
    log_verbose "  Copying file: '$source_item' to '$dest_item'"

    # If an old directory exists where the file should be, cp will fail.
    if [ -d "$dest_item" ]; then
      echo "  ERROR: Cannot copy file '$source_item' to '$dest_item' because a directory already exists at the destination. Skipping."
      ((error_count++))
      continue
    fi

    cp "$source_item" "$dest_item"
    if [ $? -eq 0 ]; then
      log_verbose "  Successfully copied file."
      ((copied_count++))
    else
      echo "  ERROR: Failed to copy file '$source_item'"
      ((error_count++))
    fi
  else
    echo "  ERROR: Source '$source_item' is not a regular file or directory. Skipping."
    ((error_count++))
  fi
  log_verbose "---"
done

echo "-------------------------------------"
echo "Backup finished."
echo "Successfully copied items: $copied_count"
echo "Items with errors/warnings: $error_count"

if [ $error_count -gt 0 ]; then
  exit 1
fi

exit 0
