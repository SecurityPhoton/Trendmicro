#!/bin/bash

echo "Enter the IP address or FQDN of the remote Trend Micro DSM host:"
read host

# Perform nslookup if the input dont looks like a ip address
if [[ $host =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Valid IP!"
else
    echo "Trying NS Lookup: "
    nslookup $host
fi

# Check if ports  4119,  4120,  4122 are open
echo "Checking for open ports  4119,  4120,  4122..."
for port in  4119  4120  4122; do
    nc -z -v -w3 $host $port
done
