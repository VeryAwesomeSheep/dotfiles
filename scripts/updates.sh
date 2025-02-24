#!/bin/bash

pacman=$(checkupdates | wc -l)
yay=$(yay -Qua | wc -l)

total="$(($pacman+$yay))"

if [ "$total" == "0" ]; then
    echo ""
  else
    echo " $total"
fi
