function find_urls {
    target_ip=$1

    echo -n "[*] Finding URLs in ${target_ip}..."
    spinner_pid=
    (
        # Get the page source and extract URLs
        urls=$(curl -ks "https://${target_ip}" | grep -oP '(https*://|www\.)[^ ]*' | tr -d '\r')

        # Print the URLs found
        if [[ ! -z "${urls}" ]]; then
            echo -e "\r[*] Finding URLs in ${target_ip}... ${GREEN}[Found]${NC}"
            echo "${urls}" | while read -r link; do
                echo "- ${link}"
            done
        else
            echo -e "\r[*] Finding URLs in ${target_ip}... ${RED}[Not Found]${NC}"
        fi

        kill $spinner_pid 2>/dev/null
    ) &
    spinner_pid=$!
    spinner $spinner_pid
    echo
}
