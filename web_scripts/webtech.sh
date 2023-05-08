function web_tech_scan() {
    target_ip="$1"
    
    # Check if whatweb is installed
    if ! command -v whatweb &> /dev/null
    then
        echo "whatweb could not be found. Please install whatweb."
        exit
    fi
    
    # Run whatweb and output to dev/null
    whatweb_output=$(whatweb -v "https://${target_ip}" 2>/dev/null)
    
    # Extract server information
    server_info=$(echo "$whatweb_output" | grep -i "server" | head -n1 | cut -d':' -f2- | tr -d ' ')
    
    # Extract X-Powered-By information
    xpoweredby_info=$(echo "$whatweb_output" | grep -i "x-powered-by" | head -n1 | cut -d':' -f2- | tr -d ' ')
    
    # Extract programming language information
    language_info=$(echo "$whatweb_output" | grep -i "language" | head -n1 | cut -d':' -f2- | tr -d ' ')
    
    # Extract framework information
    framework_info=$(echo "$whatweb_output" | grep -i "framework" | cut -d':' -f2- | tr -d ' ')
    
    # Check for WordPress or Joomla
    if echo "$whatweb_output" | grep -qi "wordpress"
    then
        echo "[*] WordPress detected"
        # echo "[*] Running WPScan..."
        # wpscan --url "https://${target_ip}" 2>/dev/null
    elif echo "$whatweb_output" | grep -qi "joomla"
    then
        echo "[*] Joomla detected"
        # echo "[*] Running JoomScan..."
        # joomscan --url "https://${target_ip}" 2>/dev/null
    fi
    
    # Print results
    echo "[*] Server: $server_info"
    echo "[*] X-Powered-By: $xpoweredby_info"
    echo "[*] Programming Language: $language_info"
    echo "[*] Frameworks: $framework_info"
}
