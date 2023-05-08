function check_public_ip_with_shared_hosts {
    target_ip=$1

    public_ip=$(dig +short $target_ip)

    echo "[*] Public IP of $target_ip is $public_ip"
    echo "[*] Checking with other domains that share the same server:"

    spinner_pid=
    
    (   
        shared_hosts=$(curl -s "https://domains.yougetsignal.com/domains.php" --data "remoteAddress=$target_ip" | awk -F '"' '{print $4}')

        for host in $shared_hosts; do
            if [[ $host == *"$target_ip"* ]]; then
                continue
            fi

            ip=$(dig +short $host)

            if [[ "$public_ip" == *"$ip,"* ]]; then
                echo -n "[$host shares the same public IP]"
            else
                echo -n "[$host does not share the same public IP]"
            fi

        done
        kill $spinner_pid 2>/dev/null
    ) &
    spinner_pid=$!
    spinner $spinner_pid
    echo
}
