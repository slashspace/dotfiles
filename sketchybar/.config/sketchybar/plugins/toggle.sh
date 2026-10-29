#!/bin/bash

case "$INFO" in
  "DaVinci Resolve" | "VirtualBox" | "remote-viewer" | "Logic Pro")
    sketchybar --bar hidden=on
    ;;
  *)
    sketchybar --bar hidden=off
    ;;
esac
