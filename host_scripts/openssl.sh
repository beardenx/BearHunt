#!/bin/bash

# Function to check for TLS 1.0 and 1.1 and weak cipher usage
function check_tls_weak_cipher() {
    # Set the target IP or hostname
    target_ip="$1"

    # Check if openssl is installed
    if ! command -v openssl &> /dev/null
    then
        echo "openssl could not be found. Please install openssl."
        exit
    fi

    # Check for TLS 1.0 and 1.1 support
    echo -n "[*] Checking for TLS 1.0 and 1.1 support... "

    if openssl s_client -connect "${target_ip}":443 -tls1_1 >/dev/null 2>&1 || openssl s_client -connect "${target_ip}":443 -tls1 >/dev/null 2>&1; then
        echo -e "${RED}Vulnerable${NC}"
    else
        echo -e "${GREEN}Not vulnerable${NC}"
    fi

    # Check for weak ciphers
    echo -n "[*] Checking for weak ciphers... "
    if openssl s_client -connect "${target_ip}":443 -cipher LOW -tls1_2 >/dev/null 2>&1 || openssl s_client -connect "${target_ip}":443 -cipher EXPORT -tls1_2 >/dev/null 2>&1; then
        echo -e "${RED}Vulnerable${NC}"
    else
        echo -e "${GREEN}Not vulnerable${NC}"
    fi
}
