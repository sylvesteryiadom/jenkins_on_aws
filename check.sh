#!/bin/bash

# Check if an IP address is valid
is_valid_ip() {
    local ip="$1"
    # Use grep to match IP address pattern
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        # Split the IP address into octets
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            # Check if each octet is in the valid range (0-255)
            if ((octet < 0 || octet > 255)); then
                return 1  # Invalid octet
            fi
        done
        return 0  # Valid IP address
    else
        return 1  # Invalid format
    fi
}

# Check IP addresses from a file
check_ip_addresses() {
    local input_file="$1"
    while IFS= read -r ip; do
        if is_valid_ip "$ip"; then
            echo "$ip is a valid IP address"
        else
            echo "$ip is an invalid IP address"
        fi
    done < "$input_file"
}

# Check IP addresses from a file named "ip_addresses.txt"
input_file="ip_addresses.txt"
if [[ -f "$input_file" ]]; then
    check_ip_addresses "$input_file"
else
    echo "Input file $input_file not found."
fi
