#!/bin/bash

CRED_FILE="$HOME/.wifi_credentials"
LOG_FILE="/var/log/wifi_login.log"

check_internet() {
    wget -q --spider http://google.com
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

save_credentials() {
    if [ ! -f "$CRED_FILE" ]; then
        read -p "Enter username: " username
        read -s -p "Enter password: " password
        echo
        echo "$username:$password" > "$CRED_FILE"
        chmod 600 "$CRED_FILE" 
        echo "Credentials saved successfully"
    fi
}

load_credentials() {
    if [ -f "$CRED_FILE" ]; then
        IFS=':' read -r username password < "$CRED_FILE"
        return 0
    else
        echo "Credentials file not found"
        return 1
    fi
}

web_login() {
    load_credentials || return 1
    
    encoded_username=$(echo "$username" | sed 's/@/%40/g')
    
    response=$(curl -s -d "mode=191&username=$encoded_username&password=$password&a=1734631999548&producttype=0" \
        -X POST "http://172.16.16.16:8090/login.xml")
    
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if check_internet; then
        echo "[$timestamp] Successfully logged in to the network" | tee -a "$LOG_FILE"
        return 0
    else
        echo "[$timestamp] Login failed or internet is still not accessible" | tee -a "$LOG_FILE"
        return 1
    fi
}

save_credentials

web_login