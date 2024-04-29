#!/bin/bash

out_file="GetBasicInformation.csv"

# Function to retrieve OS version
get_os_version() {
    os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '=' -f 2 | tr -d '"')
}

# Function to retrieve OS architecture
get_os_architecture() {
    os_architecture=$(uname -m)
}

# Function to retrieve OS service pack
get_os_service_pack() {
    os_service_pack=$(uname -r)
}

# Function to retrieve Bash version
get_bash_version() {
    bash_version=$(bash --version | head -n 1 | cut -d ' ' -f 4)
}

# Function to retrieve timezone
get_timezone() {
    timezone=$(timedatectl | grep "Timezone" | cut -d ':' -f 2 | sed 's/^[[:space:]]*//')
}

# Function to retrieve patches
get_patches() {
    patches=$(sudo apt list --upgradable 2>/dev/null | grep 'upgradable' | wc -l)
}

# Function to output data to variables and CSV
output_to_csv() {
    echo "OS Version,OS Architecture,OS Service Pack,Bash Version,Timezone,Patches" > "$out_file"
    echo "$os_version,$os_architecture,$os_service_pack,$bash_version,\"$timezone\",$patches" >> "$out_file"
    echo "results output to" "$out_file"
}
# Main function
main() {
    get_os_version
    get_os_architecture
    get_os_service_pack
    get_bash_version
    get_timezone
    get_patches
    output_to_csv
}

main
