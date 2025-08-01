#!/bin/bash

# sketchybar --set $NAME label=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{ print int($3 + $5)"%" }')
sketchybar -m --set $NAME label=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{ printf("%02.0f\n", $3 + $5) }')%