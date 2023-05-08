#!/bin/bash

# Sources file for host scanning
source "$(dirname "$0")/host_scripts/ping.sh"
source "$(dirname "$0")/host_scripts/spinner.sh"
source "$(dirname "$0")/host_scripts/wafw00f.sh"
source "$(dirname "$0")/host_scripts/traceroute.sh"
source "$(dirname "$0")/host_scripts/nmap.sh"
source "$(dirname "$0")/host_scripts/openssl.sh"

# Sources file for web scanning
source "$(dirname "$0")/web_scripts/dig.sh"
source "$(dirname "$0")/web_scripts/scrap.sh"
source "$(dirname "$0")/web_scripts/webtech.sh"



# Set some variables with ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\033[0;37m
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
        ⠀⠀⣠⡶⠟⠛⠛⢷⣦⣀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⢀⣀⣴⠾⠛⠛⠻⢶⣄⠀⠀
        ⠀⢰⡟⣡⠖⣷⣆⡀⠈⠛⠉⠉⠉⠉⠙⠛⠋⠉⠉⠉⠉⠛⠁⢀⣲⣞⠲⡍⢿⡆⠀
        ⠀⠸⣧⠁⢠⡤⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠲⣤⠀⠀⣾⠇⠀
        ⠀⠀⠙⣷⠟⠁⠀⠀⠀⣀⡤⣤⡀⠀⠀⠀⠀⠀⢀⡤⢤⣀⠀⠀⠀⠈⢳⣿⠋⠀⠀
        ⠀⢀⣾⠏⠀⠀⠀⢀⠾⠓⠀⠀⠹⣦⡀⠀⢀⣼⠋⠀⠀⠚⢧⡀⠀⠀⠀⠹⣷⡀⠀
        ⢀⣿⡏⠀⠀⠀⠀⠀⠀⣴⡾⠶⣤⡈⣿⠀⣿⢁⣤⠶⢷⣄⠀⠁⠀⠀⠀⠀⢻⣷⠀
        ⢸⣿⡇⠀⠀⠀⢀⡆⠀⠘⢷⣤⣼⠟⠉⠉⠙⢻⣧⣴⡿⠃⠀⢠⠀⠀⠀⠀⢸⣿⡇     
       
              BearHunt [Bear Hunting v2.2]
              Github: github.com/beardenx
                   Author: beardenx
\033"
echo "===================================================="
echo "BearHunt - A basic enumeration tool for host and web"
echo "===================================================="
echo
# Function to show a fancy loading animation
# Define spinner function
spinner() {
    local pid=$1
    local spin='|/-\'
    local i=0
    printf " "
    while kill -0 $pid >/dev/null 2>&1
    do
        printf "\b${spin:$i:1}"
        i=$(( (i+1) %4 ))
        sleep 0.1
    done
    printf " \r"
}

# Check if the script was run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# Parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --host)
            type="host"
            shift # past argument
            target_ip="$1"
            shift # past value
            ;;
        --web)
            type="web"
            shift # past argument
            target_ip="$1"
            shift # past value
            ;;

        --subdomain)
            type="subdomain"
            shift # past argument
            target_ip="$1"
            shift # past value
            ;;

        *)
            echo "Invalid argument: $key"
            exit 1
            ;;
    esac
done

# Verify required arguments were provided
if [[ -z $type ]] || [[ -z $target_ip ]]
then
    echo "Usage: $0 --host [IP address|domain] | For scanning a single host"
    echo "Usage: $0 --web [IP address|domain] | For scanning a single website"
    echo "Usage: $0 --subdomain [domain] | For scanning a subdomain website"

    exit 1
fi

# Perform scan based on user input
if [[ $type == "host" ]]
then
    echo "Scanning a host: ${BLUE}[$target_ip]${NC}"
    echo
    # Insert command to scan host here
    
    check_target_alive $target_ip
    check_waf $target_ip
    check_firewall $target_ip
    nmap_scan $target_ip
    check_tls_weak_cipher $target_ip

elif [[ $type == "web" ]]
then
    echo -e "Scanning website: ${BLUE}[$target_ip]${NC}"
    echo
    # Insert command to scan website here
    check_target_alive $target_ip
    check_waf $target_ip
    check_firewall $target_ip
    nmap_scan $target_ip
    check_tls_weak_cipher $target_ip
    echo
    find_urls $target_ip
    # web_tech_scan $target_ip

fi

