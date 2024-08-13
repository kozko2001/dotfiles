#!/usr/bin/env bash
swayidle -w \
timeout 100 'sleep 5; hyprctl dispatch dpms off; [ -f /sys/class/power_supply/ACAD/online ] && [ "$(cat /sys/class/power_supply/ACAD/online)" -eq 0 ] && systemctl suspend'
