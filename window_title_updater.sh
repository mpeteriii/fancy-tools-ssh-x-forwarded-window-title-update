#!/bin/bash

while true; do
    window_info=$(wmctrl -l)
    # Loop through each window info
    while IFS= read -r line; do
        # Extract window ID, client machine, and title
        window_id=$(echo "$line" | awk '{print $1}')
        client_machine=$(echo "$line" | awk '{print $3}')
        title=$(echo "$line" | awk '{$1=$2=$3=""; sub(/^[ \t]+/, "", $0); print}')
    
        # Check if client machine is not "desktop" and title is not already prepended
        if [ "$client_machine" != "N/A" ] && [ "$client_machine" != "desktop" ] && [[ ! "$title" =~ ^"#$client_machine#" ]]; then
            # Prepend client machine name to the title
            new_title="#$client_machine# - $title"
    
            # Change window title using wmctrl
            wmctrl -i -r $window_id -T "$new_title"
        fi
    done <<< "$window_info"
    sleep 2
done
