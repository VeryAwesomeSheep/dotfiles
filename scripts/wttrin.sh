#!/bin/bash

CACHE_FILE="$HOME/.cache/wttrin.json"
MAX_AGE=60 # Maximum allowed age of the cache file in minutes

is_cache_valid() {
  if [ -z "$(find "$CACHE_FILE" -mmin -"$MAX_AGE" 2>/dev/null)" ]; then
    return 1 # Cache too old or missing
  fi
  if ! jq -e '.current_condition[0]' "$CACHE_FILE" >/dev/null 2>&1; then
    return 1 # Invalid JSON
  fi

  return 0
}

get_weather_icon() {
  local code="$1"
  case "$code" in
    113) echo "" ;; # Sunny
    116) echo "" ;; # PartlyCloudy
    119) echo "" ;; # Cloudy
    122) echo "" ;; # VeryCloudy
    143|248|260) echo "" ;; # Fog
    176|263|353) echo "" ;; # LightShowers
    179|362|365|374) echo "" ;; # LightSleetShowers
    182|185|281|284|311|314|317|350|377) echo "" ;; # LightSleet
    200|386) echo "" ;; # ThunderyShowers
    227|320) echo "" ;; # LightSnow
    230|329|332|338) echo "" ;; # HeavySnow
    266|293|296) echo "" ;; # LightRain
    299|305|356) echo "" ;; # HeavyShowers
    302|308|359) echo "" ;; # HeavyRain
    323|326|368) echo "" ;; # LightSnowShowers
    335|371|395) echo "" ;; # HeavySnowShowers
    389) echo "" ;; # ThunderyHeavyRain
    392) echo "" ;; # ThunderySnowShowers
    *) echo "" ;; # Unknown
  esac
}

case "$1" in
  --fetch)
  # Check if a location argument was provided
  LOCATION=""
  if [ -n "$2" ]; then
    # Replace spaces with '+'
    LOCATION="${2// /+}"
  fi

  # Fetch JSON from wttr.in (with location and forced metric units)
  if curl -s "https://wttr.in/${LOCATION}?format=j1&m" > "${CACHE_FILE}.tmp"; then
    mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
    exit 0
  else
    rm -f "${CACHE_FILE}.tmp"
    exit 1
  fi
  ;;

  --simple)
    if ! is_cache_valid; then echo ""; exit 0; fi

    {
    read -r code
    read -r feels
    } < <(jq -r '.current_condition[0] | .weatherCode, .FeelsLikeC' "$CACHE_FILE")

    icon=$(get_weather_icon "$code")
    echo "${icon} ${feels}°C"
    ;;

  --waybar)
    if ! is_cache_valid; then echo '{"text": "", "tooltip": ""}'; exit 0; fi

    {
      read -r temp
      read -r code
      read -r feels
      read -r desc
      read -r wind_dir
      read -r wind_speed
      read -r precip
      read -r humidity
      read -r sunrise
      read -r sunset
    } < <(jq -r '.current_condition[0] as $current | .weather[0].astronomy[0] as $astronomy | $current.temp_C, $current.weatherCode, $current.FeelsLikeC, $current.weatherDesc[0].value, $current.winddir16Point, $current.windspeedKmph, $current.precipMM, $current.humidity, $astronomy.sunrise, $astronomy.sunset' "$CACHE_FILE")

    icon=$(get_weather_icon "$code")

    # Convert 12h to 24h format
    sunrise=$(date -d "$sunrise" +%H:%M 2>/dev/null || echo "$sunrise")
    sunset=$(date -d "$sunset" +%H:%M 2>/dev/null || echo "$sunset")

    # 'c' is important here as it outputs JSON on a single line which is needed for waybar
    jq -cn \
      --arg text "$icon ${feels}°C" \
      --arg icon "$icon" \
      --arg desc "$desc" \
      --arg temp "$temp" \
      --arg wind_dir "$wind_dir" \
      --arg wind_speed "$wind_speed" \
      --arg precip "$precip" \
      --arg humidity "$humidity" \
      --arg sunrise "$sunrise" \
      --arg sunset "$sunset" \
      '{
        "text": $text,
        "tooltip": "<tt>\($icon)  \($desc)\n  \($temp)°C\n󱗺  \($wind_dir) - \($wind_speed) km/h\n  \($precip)mm\n  \($humidity)%\n  \($sunrise)\n  \($sunset)</tt>"
      }'
    ;;

  --temperature)
    if ! is_cache_valid; then echo ""; exit 0; fi

    jq -r '.current_condition[0].FeelsLikeC + "°C"' "$CACHE_FILE"
    ;;

  *)
    echo "Usage: $0 {--fetch <location>|--simple|--waybar|--temperature}"
    exit 1
    ;;
esac
