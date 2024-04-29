#!/bin/bash

# Get all cron jobs and store them in a variable
cronjobs=$(crontab -l)

# Check if there are any cron jobs
if [ -z "$cronjobs" ]; then
    echo "No cron jobs found."
    exit 1
fi

# Create a CSV file
csv_file="cron_jobs.csv"

# Header for CSV file
echo "Schedule,Command" > "$csv_file"

# Parse each cron job and append it to the CSV file
while IFS= read -r line; do
    # Extract schedule and command
    schedule=$(echo "$line" | awk '{$1=$NF=""; print $0}')
    command=$(echo "$line" | awk '{$1=$NF=""; sub(/^[ \t]+/,""); print $0}')
    
    # Append to CSV file
    echo "$schedule,$command" >> "$csv_file"
done <<< "$cronjobs"

echo "Cron jobs successfully exported to $csv_file"
