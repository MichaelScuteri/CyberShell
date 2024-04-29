#!/bin/bash

# Function to retrieve process information
get_process_info() {
    # Get process information and store it in arrays
    pid=($(ps -eo pid | tail -n +2))
    name=($(ps -eo comm | tail -n +2))
    cmdline=($(ps -eo cmd | tail -n +2))
    state=($(ps -eo state | tail -n +2))
    ppid=($(ps -eo ppid | tail -n +2))
    parent_name=($(ps -eo comm,ppid | tail -n +2))
    create_time=($(ps -eo lstart | tail -n +2))
    path=($(ps -eo cmd | tail -n +2 | awk '{print $1}'))
    memory_size=($(ps -eo rss | tail -n +2))
    thread_count=($(ps -eo nlwp | tail -n +2))
    username=($(ps -eo user | tail -n +2))
}

# Function to combine variables into CSV format and output to file
output_to_csv() {
    echo "PID,Name,CommandLine,State,ParentPID,ParentName,CreationTime,Path,MemorySize,ThreadCount,Username" > GetProcesses.csv
    for ((i=0; i<${#pid[@]}; i++)); do
        echo "${pid[i]},${name[i]},${cmdline[i]},${state[i]},${ppid[i]},${parent_name[i]},\"${create_time[i]}\",${path[i]},${memory_size[i]},${thread_count[i]},${username[i]}" >> GetProcesses.csv
    done
}

main() {
    get_process_info
    output_to_csv
}

main
