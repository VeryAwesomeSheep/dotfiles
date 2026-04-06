#!/bin/bash

# Handles various events and sends notification about them.

# IDs for replacing existing notifications
VOL_ID=10001
MIC_ID=10002
BT_ID=10003
BAT_ID=10004
BRI_ID=10005

notify_volume() {
  local volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')

  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'; then
    icon="volume_off.svg"
  else
    if [ "$volume" -gt 65 ]; then
      icon="volume_high.svg"
    elif [ "$volume" -ge 33 ]; then
      icon="volume_medium.svg"
    else
      icon="volume_low.svg"
    fi
  fi

  dunstify -t 1500 -a "System" -r "$VOL_ID" -i "$HOME/.config/icons/${icon}" "Volume" "${volume}%"
}

handle_event() {
  local event="$1"
  local action="$2"
  local param="$3"

  case "$event" in
    volume)
      case "$action" in
        up)
          wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          notify_volume
          ;;
        down)
          wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          notify_volume
          ;;
        toggle)
          wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          notify_volume
          ;;
        *)
          echo "Error: Unknown volume action '$action'"
          ;;
      esac
      ;;

    mic)
      case "$action" in
        toggle)
          wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q '\[MUTED\]'; then
            dunstify -t 1500 -a "System" -r "$MIC_ID" -i "$HOME/.config/icons/microphone_off.svg" "Microphone" "Muted"
          else
            dunstify -t 1500 -a "System" -r "$MIC_ID" -i "$HOME/.config/icons/microphone.svg" "Microphone" "Unmuted"
          fi
          ;;
        *)
          echo "Error: Unknown mic action '$action'"
          ;;
      esac
      ;;

    bluetooth)
      case "$action" in
        connected)
          dunstify -t 3000 -a "System" -r "$BT_ID" -i "$HOME/.config/icons/bluetooth.svg" "Bluetooth Connected" "${param}"
          ;;
        disconnected)
          dunstify -t 3000 -a "System" -r "$BT_ID" -i "$HOME/.config/icons/bluetooth.svg" "Bluetooth Disconnected" "${param}"
          ;;
        *)
          echo "Error: Unknown bluetooth action '$action'"
          ;;
      esac
      ;;

    # battery)
    #   case "$action" in
    #     charging)
    #       dunstify -t 1500 -a "System" -r "$BAT_ID" -i "$HOME/.config/icons/bolt.svg" "Battery Charging" "${param}"
    #       ;;
    #     discharging)
    #       dunstify -t 1500 -a "System" -r "$BAT_ID" -i "$HOME/.config/icons/bluetooth.svg" "Battery Discharging" "${param}"
    #       ;;
    #     warning)
    #       dunstify -t 3000 -a "System" -r "$BAT_ID" -i "$HOME/.config/icons/battery_quarter.svg" "Battery Level Warning" "${param}"
    #       ;;
    #     *)
    #       echo "Error: Unknown battery action '$action'"
    #       ;;
    #   esac
    #   ;;

    # brightness)
    #   case "$action" in
    #     up)
    #       dunstify -t 1500 -a "System" -r "$BRI_ID" -i "$HOME/.config/icons/sun.svg" "Brightness Up" "${param}"
    #       ;;
    #     down)
    #       dunstify -t 1500 -a "System" -r "$BRI_ID" -i "$HOME/.config/icons/sun.svg" "Brightness Down" "${param}"
    #       ;;
    #     *)
    #       echo "Error: Unknown brightness action '$action'"
    #       ;;
    #   esac
    #   ;;

    *)
      echo "Usage: $0 {volume|mic|bluetooth|battery|brightness} {action} [value]"
      exit 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <event> <action> [value]"
    echo "Example 1: $0 volume up 75"
    echo "Example 2: $0 mic mute"
    echo "Example 3: $0 bluetooth connected 'Headphones'"
    exit 1
  fi

  handle_event "$1" "$2" "$3"
fi
