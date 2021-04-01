#!/usr/bin/env bash

# Terminate already running bar instances
pkill polybar

# Launch bar
echo "---" | tee -a /tmp/polybar.log
polybar example 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
