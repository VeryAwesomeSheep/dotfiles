#!/bin/bash

# Help message
help() {
    echo "Usage: $0 [option] <location>"
    echo ""
    echo "Options:"
    echo "  --simple    returns basic report (default)"
    echo "  --full      returns full report"
    echo "  --waybar    returns full report in json for waybar"
    echo "  --help      print this usage message"
    echo ""
    echo "Location:"
    echo "  <none>      get location based on your IP"
    echo "  New+York    example"
    echo "  Paris       example"
    echo ""
}

# Variables
type="simple"  # Default type
location=""

# Check for help option
if [[ "$1" == "--help" ]]; then
  help
  exit 0
fi

# Handle options and location
while [[ $# -gt 0 ]]; do
  case "$1" in
    --simple)
        type="simple"
        shift
        ;;
    --full)
        type="full"
        shift
        ;;
    --waybar)
        type="waybar"
        shift
        ;;
    --) # End of options, treat remaining arguments as location
        shift
        location="$1"
        shift
        break
        ;;
    -*) # Invalid option
        echo "Error: Invalid option '$1'." >&2
        help
        exit 1
        ;;
    *)  # Treat as location if no option is given
        location="$1"
        shift
        break
        ;;
  esac
done

# Request based on inputs
case "$type" in
    simple)
        response=$(curl -s "wttr.in/$location?format=%l:+%c+%t+(%f)")
        if [ "$response" == "" ]; then
            echo "wttr.in error"
        else
            city=$(echo "$response" | awk '{print $1}' | cut -d ':' -f 1)
            icon=$(echo "$response" | awk '{print $2}')
            temperature=$(echo "$response" | awk '{print $3}')
            feels_like=$(echo "$response" | awk '{print $4}' | cut -d '(' -f 2 | cut -d ')' -f 1) # Extract from parentheses

            echo "$city $icon $temperature ($feels_like)"
        fi
        ;;
    full)
        response=$(curl -s "wttr.in/$location?format=%l:+%c+%t+(%f)+%h+%w+%p+%P+%S+%s")
        if [ "$response" == "" ]; then
            echo "wttr.in error"
        else
            city=$(echo "$response" | awk '{print $1}' | cut -d ':' -f 1)
            icon=$(echo "$response" | awk '{print $2}')
            temperature=$(echo "$response" | awk '{print $3}')
            feels_like=$(echo "$response" | awk '{print $4}' | cut -d '(' -f 2 | cut -d ')' -f 1) # Extract from parentheses
            humidity=$(echo "$response" | awk '{print $5}')
            wind=$(echo "$response" | awk '{print $6}')
            precipitation=$(echo "$response" | awk '{print $7}')
            pressure=$(echo "$response" | awk '{print $8}')
            sunrise=$(echo "$response" | awk '{print $9}')
            sunset=$(echo "$response" | awk '{print $10}')

            echo "$city: $icon, Temperature: $temperature, Feels like: $feels_like, Humidity: $humidity, Wind: $wind, Precipitation: $precipitation, Pressure: $pressure, Sunrise: $sunrise, Sunset: $sunset"
        fi
        ;;
    waybar)
        response=$(curl -s "wttr.in/$location?format=%l:+%c+%t+(%f)+%h+%w+%p+%P+%S+%s")
        if [ "$response" == "" ]; then
            echo "{\"text\":\"wttr.in error\", \"tooltip\":\"No data\"}"
        else
            city=$(echo "$response" | awk '{print $1}' | cut -d ':' -f 1)
            icon=$(echo "$response" | awk '{print $2}')
            temperature=$(echo "$response" | awk '{print $3}')
            feels_like=$(echo "$response" | awk '{print $4}' | cut -d '(' -f 2 | cut -d ')' -f 1) # Extract from parentheses
            humidity=$(echo "$response" | awk '{print $5}')
            wind=$(echo "$response" | awk '{print $6}')
            precipitation=$(echo "$response" | awk '{print $7}')
            pressure=$(echo "$response" | awk '{print $8}')
            sunrise=$(echo "$response" | awk '{print $9}')
            sunset=$(echo "$response" | awk '{print $10}')

            echo "{\"text\":\"$icon $temperature ($feels_like)\",\"tooltip\":\"     Location: $city\n     Humidity: $humidity\n    Wind: $wind\n    Precipitation: $precipitation\n󰊚    Pressure: $pressure\n   Sunrise: $sunrise\n   Sunset: $sunset\"}"
        fi
        ;;
esac

exit 0
