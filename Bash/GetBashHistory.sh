#!/bin/bash

# Define the output CSV file
output_file="bash_history.csv"

# Check if the Bash history file exists
if [ -f "$HOME/.bash_history" ]; then
    # Write header to CSV file
    echo "User,Command" > "$output_file"

    # Extract and format each command from the history, along with the user, and write to CSV
    while IFS= read -r command; do
        # Retrieve the username
        user=$(whoami)
        # Write the user and command to the CSV file
        echo "\"$user\",\"$command\"" >> "$output_file"
    done < "$HOME/.bash_history"
    
    echo "Results output to $output_file"
else
    echo "Bash history file not found."
fi
