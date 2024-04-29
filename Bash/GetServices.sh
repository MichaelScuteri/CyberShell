#!/bin/bash

# Function to get the creator of a process
get_creator() {
    pid=$1
    creator=$(ps -o user= -p $pid)
    echo "$creator"
}

# Output CSV header
echo "Name,Command Line,State,Started Time,Created Time,PID,Created By" > daemon_info.csv

# Get list of running daemons
daemons=$(ps aux | awk '{print $11}' | grep "/")

# Loop through each daemon
for daemon; do
    # Get daemon information
    name=$(basename $daemon)
    command_line=$(ps -p $(pgrep -f $daemon) -o cmd --no-headers)
    state=$(ps -p $(pgrep -f $daemon) -o state --no-headers)
    started_time=$(ps -p $(pgrep -f $daemon) -o lstart --no-headers)
    pid=$(pgrep -f $daemon)
    created_time=$(ps -p $pid -o lstart --no-headers)
    created_by=$(get_creator $pid)
    
    # Output information to CSV file
    echo "$name,\"$command_line\",$state,$started_time,$created_time,$pid,$created_by" >> daemon_info.csv
done <<< "$daemons"

echo "Daemon information has been saved to daemon_info.csv"
