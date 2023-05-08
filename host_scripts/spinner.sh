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