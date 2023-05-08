#!/bin/bash

source "$(dirname "$0")/host_scripts/spinner.sh"
# Initialize variable to track target status
alive=0

function check_target_alive() {
    target_ip=$1

    while true; do

    # Use ping to check if target is alive
    ping -c 1 $target_ip > /dev/null 2>&1 & pid=$!
    spinner $pid
    wait $pid

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo -e "[*] Ping a target ...${GREEN} [pingable]${NC}"
        break
    else
        echo -e "[*] Ping a target ...${RED} [unreachable, possible ICMP is blocking]${NC}"
        echo
        read -p "Do you want to continue scanning? (y/n)" continue_scan
        if [ "$continue_scan" == "y" ]; then
            break
        elif [ "$continue_scan" == "n" ]; then
            exit
        else
            echo "Invalid input. Please enter 'y' or 'n'."
        fi
    fi
done
}

# Define other functions related to scanning here
