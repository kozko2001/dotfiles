#!/usr/bin/env bash
swayidle -w \
timeout 100 'sleep 5; hyprctl dispatch dpms off' 
