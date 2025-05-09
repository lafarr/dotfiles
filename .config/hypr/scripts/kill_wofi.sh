#!/usr/bin/env bash

if pgrep wofi > /dev/null; then
  pkill wofi
else
  true 
fi
