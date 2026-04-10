#!/bin/bash

# This script analysis basic server performance

# Clear terminal window
clear

# Total CPU usage
# Rounded to .01
echo "Total CPU usage:"
grep "cpu[^0-9]" /proc/stat | awk '{ print int((100 - ($5 * 100) / ($2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10)) * 100 + 0.5) / 100 "%" }'
echo

# Total memory usage (Free vs Used including percentage)
# Rounded to .01
echo "Total memory usage:"
free | grep "Mem:" | awk '{ print int(($3 / $2) * 10000 + 0.5) / 100 "%" }'
echo

# Total disk usage (Free vs Used including percentage)
echo "Total disk usage:"
df --total | grep "total" | awk '{ print $5 }'
echo

# Top 5 processes by CPU usage
echo "Top 5 processes by CPU usage:"
ps axu --sort %cpu | tail -n 5 | tac | awk '{ print $1, $2, $3, $11 }' | column -t
echo

# Top 5 processes by memory usage
echo "Top 5 processes by memory usage:"
ps axu --sort %mem | tail -n 5 | tac | awk '{ print $1, $2, $4, $11 }' | column -t
echo
