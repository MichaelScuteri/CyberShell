#!/bin/bash

# Get the list of startup applications and set outfile
startup_apps=$(ls /etc/xdg/autostart/*.desktop 2>/dev/null)

# Set output file
out_file="GetStartup.csv"

# Check if there are any startup applications
if [ -z "$startup_apps" ]; then
    echo "No startup applications found."
else
    # Create CSV file with header
    echo "Name,Path,SHA256,Permissions,Owner,Size(bytes),Created Time,Modified Time,Accessed Time" > "$out_file"

    # Loop through each startup application
    for app in $startup_apps; do
        app_name=$(basename "$app" .desktop)
        hash=$(sha256sum "$app" | awk '{print $1}')  
        permissions=$(stat -c '%A' "$app")
        owner=$(stat -c '%U' "$app")             
        size=$(stat -c '%s' "$app")                           
        modified_time=$(stat -c '%y' "$app")       
        accessed_time=$(stat -c '%x' "$app") 
        created_time=$(sudo stat -c '%w' "$app")
        
        # Append application details to CSV file
        echo "$app_name,$app,$hash,$permissions,$owner,$size,$created_time,$modified_time, $accessed_time" >> "$out_file"
    done
fi

echo "Results output to $out_file"
