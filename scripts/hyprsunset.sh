#!/bin/bash

# Toggle hyprsunset

# Desired temperature
temperature=3500

# Get pid of hyprsunset
pid=$(pgrep -f "hyprsunset -t $temperature")

if [ -n "$pid" ]; then
    kill $pid
else
    hyprsunset -t $temperature &
fi

