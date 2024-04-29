#!/bin/bash

# Define output file
output_file="GetUserDownloads.csv"

# Write header to CSV file
echo "Name,Path,SHA256,Permissions,Owner,Group,Size,Created,Modified,Accessed" > "$output_file"

# Loop through all user directories
for user_dir in /home/*; do
    user=$(basename "$user_dir")
    downloads_dir="$user_dir/Downloads"

    # Check if Downloads directory exists
    if [ -d "$downloads_dir" ]; then
        # Find all files in Downloads directory
        while IFS= read -r file_path; do
            # Get file name
            file_name=$(basename "$file_path")

            # Get SHA256 hash
            sha256=$(sha256sum "$file_path" | awk '{print $1}')

            # Get permissions
            permissions=$(stat -c "%A" "$file_path")

            # Get owner
            owner=$(stat -c "%U" "$file_path")

            # Get group
            group=$(stat -c "%G" "$file_path")

            # Get size
            size=$(stat -c "%s" "$file_path")

            # Get creation time
            created=$(stat -c "%y" "$file_path")

            # Get modification time
            modified=$(stat -c "%y" "$file_path")

            # Get access time
            accessed=$(stat -c "%x" "$file_path")

            # Write file information to CSV
            echo "\"$file_name\",\"$file_path\",\"$sha256\",\"$permissions\",\"$owner\",\"$group\",\"$size\",\"$created\",\"$modified\",\"$accessed\",\"$version\"" >> "$output_file"
        done < <(find "$downloads_dir" -type f)
    fi
done

echo "Results output to $output_file"
