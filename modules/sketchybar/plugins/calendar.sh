#!/bin/bash

weekday_num="$(date '+%u')"

case "$weekday_num" in
  1) weekday="周一" ;;
  2) weekday="周二" ;;
  3) weekday="周三" ;;
  4) weekday="周四" ;;
  5) weekday="周五" ;;
  6) weekday="周六" ;;
  7) weekday="周日" ;;
  *) weekday="" ;;
esac

sketchybar --set "$NAME" icon="$(date '+%-m月%-d日') ${weekday} $(date '+%H:%M')"
