function check_firewall() {
    target_ip="$1"
    echo -n "[*] Checking for firewall/load balancer protection..."
    spinner_pid=
    (
        # check if ping is allowed and the target is reachable
        if ping -c 1 -w 2 $target_ip > /dev/null 2>&1; then
            # try to perform a traceroute to the target
            traceroute_output=$(traceroute $target_ip 2>/dev/null)
            

            # check if traceroute was successful
            if [[ $? -eq 0 ]]; then
                # check if there are any hops with the target IP address
                if echo $traceroute_output | grep -q $target_ip; then
                    echo -e "\r[*] Checking for firewall/load balancer protection... ${GREEN}[No firewall/load balancer detected]${NC}"
                else
                    echo -e "\r[*] Checking for firewall/load balancer protection... ${RED}[Firewall/load balancer detected]${NC}"
                fi
            else
                echo -e "\r[*] Checking for firewall/load balancer protection... ${RED}[Unreachable]${NC}"
            fi
            kill $spinner_pid 2>/dev/null

            # check if ping is blocked and the target is unreachable
        elif ping -c 1 -w 2 $target_ip -f > /dev/null 2>&1; then
            echo -e "\r[*] Checking for firewall/load balancer protection... ${RED}[Protected by a firewall]${NC}"
            kill $spinner_pid 2>/dev/null

            # if none of the above, the target is unreachable
        else
            echo -e "\r[*] Checking for firewall/load balancer protection... ${RED}[Unreachable]${NC}"
            kill $spinner_pid 2>/dev/null
        fi
    ) &
    spinner_pid=$!
    spinner $spinner_pid
}
