#!/bin/bash


function check_waf(){
    local target_ip=$1

    echo -n "[*] Check if the domain/ip is protected by WAF... "

    # Run wafw00f and show a spinner while it's running
    spinner_pid=
    (
        waf_output=$(wafw00f $target_ip 2>/dev/null)
        kill $spinner_pid 2>/dev/null
        # Check if Wafw00f detected a WAF and summarize output
        if echo "$waf_output" | grep -qi "is behind"; then
            echo -e "\r[*] Check if the domain/ip is protected by WAF... ${RED}[WAF Detected]${NC}"
            kill $spinner_pid 2>/dev/null
        else
            echo -e "\r[*] Check if the domain/ip is protected by WAF... ${GREEN}[WAF Undetected]${NC}"
            kill $spinner_pid 2>/dev/null
        fi
    ) &
    spinner_pid=$!
    spinner $spinner_pid
}
