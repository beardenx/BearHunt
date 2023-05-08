nmap_scan() {
    target_ip=$1
    echo -n "[*] Checking Open Port and Services..."
    spinner_pid=
    (
        nmap_scan=$(sudo nmap -sV -T4 $target_ip)
        nmap_output=$(echo "$nmap_scan" | grep -E "^(PORT|.*open.*)")
        echo -e "\r[*] Checking Open Port and Services... ${GREEN}[Completed]${NC}"
        echo
        echo "$nmap_output" 
        kill $spinner_pid 2>/dev/null
    ) &
    spinner_pid=$!
    spinner $spinner_pid
    wait $spinner_pid
    echo
}
