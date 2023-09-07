#!/bin/bash

# Script name: System Monitoring and Reporting
# Author name and number: Lixdel Louisse L. Aggabao (041081985)
# Course code and lab section number: CST8102 - 313
# Script file name: system_report.sh
# Date completed: August 5, 2023
# Description: This script provides a menu-based system monitoring and reporting tool. It allows the user to generate a system report, create an archive of the report, and exit the program.

# Purpose of function: Displays the menu options.
# Author name and number: Lixdel Louisse L. Aggabao (041081985)
# Date written: July 31, 2023
# Algorithm:
# 1. Use echo statement to display the script name.
# 2. Use echo statements to display each menu option to the user.
function display_menu() {
    echo "System Monitoring and Reporting";
    echo "++++++++++++++++++++++++++++++++++"
    echo "1. Generate System Report"
    echo "2. Create Archive"
    echo "3. Exit"
    echo "++++++++++++++++++++++++++++++++++"
}

# Purpose of function: Performs extractions/calculations and generates the system report.
# Author name and number: Lixdel Louisse L. Aggabao (041081985)
# Date written: July 31, 2023
# Algorithm:
# 1. Extract CPU, memory, and disk information.
# 2. Log the extracted information along with system details to a file named "system_report.log".
# 3. Check status and provide feedback for the extracted information.
# 4. Log the feedback to the log file.
function generate_system_report() {
    # CPU information extraction
    cpu_threshold=80
    cpu_load=$(uptime | rev | cut -d ' ' -f 3 | rev | cut -d ',' -f 1)

    # Memory information extraction
    memory_threshold=50
    memory_statistics=$(free -m | sed -n '2p')
    total_memory=$(echo $memory_statistics | cut -d ' ' -f 2)
    free_memory=$(echo $memory_statistics | cut -d ' ' -f 4)
    memory_usage_percentage=$(echo "scale=2; (($total_memory - $free_memory) / $total_memory) * 100" | bc)
    memory_usage_percentage=$(echo "scale=0; $memory_usage_percentage / 1" | bc)

    # Disk usage information extraction
    disk_threshold=70
    disk_usage_information=$(df -h / | sed -n '2p')
    disk_total=$(echo $disk_usage_information | cut -d ' ' -f 2 | cut -d 'G' -f 1)
    disk_used=$(echo $disk_usage_information | cut -d ' ' -f 3 | cut -d 'G' -f 1)
    disk_free=$(echo $disk_usage_information | cut -d ' ' -f 4 | cut -d 'G' -f 1)
    disk_usage_percentage=$(echo "scale=2; (($disk_total - $disk_free) / $disk_total) * 100" | bc)
    disk_usage_percentage=$(echo "scale=0; $disk_usage_percentage / 1" | bc)

    # Log system report
    echo "Generating system report..."
    echo $(date) >> system_report.log
    echo "System information:" | tee -a system_report.log
    echo "Hostname: $(hostname)" | tee -a system_report.log
    echo "Operating System: $(uname -s)" | tee -a system_report.log
    echo "Kernel Version: $(uname -r)" | tee -a system_report.log
    echo "CPU Information:" | tee -a system_report.log
    echo $(lscpu | grep 'Model name') | tee -a system_report.log
    echo "Total Memory: $total_memory MB" | tee -a system_report.log
    echo "Free Memory: $free_memory MB" | tee -a system_report.log
    echo "Disk Usage Information:" | tee -a system_report.log
    echo "Total: ${disk_total}G, Used: ${disk_used}G, Free: ${disk_free}G" | tee -a system_report.log
    echo | tee -a system_report.log
    
    # Check CPU load status
    if (( $(echo "$cpu_load < $cpu_threshold" | bc -l) )); then
        echo "SUCCESS: CPU load is within acceptable limits (${cpu_load}%)" | tee -a system_report.log
    else
        echo "WARNING: CPU load exceeds the ${cpu_threshold}% threshold" | tee -a system_report.log
    fi
    
    # Check memory usage status
    if (( $(echo "$memory_usage_percentage < $memory_threshold" | bc -l) )); then
        echo "SUCCESS: Memory usage is within acceptable limits (${memory_usage_percentage}%)" | tee -a system_report.log
    else
        echo "WARNING: Memory usage exceeds the ${memory_threshold}% threshold" | tee -a system_report.log
    fi
    
    # Check disk usage status
    if (( $(echo "$disk_usage_percentage < $disk_threshold" | bc -l) )); then
        echo "SUCCESS: Disk usage is within acceptable limits (${disk_usage_percentage}%)" | tee -a system_report.log
    else
        echo "WARNING: Disk usage exceeds the ${disk_threshold}% threshold" | tee -a system_report.log
    fi

    echo | tee -a system_report.log
}

# Purpose of function: Creates an archive of the system report log file.
# Author name and number: Lixdel Louisse L. Aggabao (041081985)
# Date written: July 31, 2023
# Algorithm:
# 1. Check if the "system_report.log" file exists and is not empty.
# 2. Generate a new system report if it does not exist or is empty before creating the archive file "system_report_archive.tar.gz" containing the "system_report.log" file.
# 3. Create the archive file "system_report_archive.tar.gz" containing the "system_report.log" file if it exists or is not empty.
function create_archive() {
    log_file="system_report.log"
    archive_file="system_report_archive.tar.gz"

    # Check if log file exists and is not empty
    if [[ -f "$log_file" ]] && [[ -s "$log_file" ]]; then
        tar -czf "$archive_file" "$log_file"
        echo "Archive created successfully."
    else
        echo "Error: Log file does not exist or is empty. Generating a new report before creating the archive."
        generate_system_report
        tar -czf "$archive_file" "$log_file"
        echo "Archive created successfully."
    fi
}

# Infinite loop to display the menu and handle user choices
while true
do
    display_menu
    read -p "Enter your choice: " choice
    case $choice in
        1)
            generate_system_report
            ;;
        2)
            create_archive
            ;;
        3)
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid option! Please choose a valid menu item."
            ;;
    esac
done
