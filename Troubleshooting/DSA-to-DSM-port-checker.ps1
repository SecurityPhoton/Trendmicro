# Prompt user to input an IP address or FQDN
$target = Read-Host "Enter IP address or FQDN"

# Check if input is an IP address or FQDN
if ($target -as [ipaddress]) {
    # Input is an IP address, use it directly
    $ipAddress = $target
}
else {
    # Input is an FQDN, resolve it using nslookup
    $resolvedIp = (nslookup $target | Select-String -Pattern "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}").Matches.Value
    if ($resolvedIp) {
        $ipAddress = $resolvedIp
        Write-Host "Resolved IP address: $resolvedIp"
    }
    else {
        Write-Host "Failed to resolve FQDN."
        exit
    }
}

# Array of ports to check
$ports = @(4120, 4122, 4119)
Write-Host "=====================Deep Security Agent Checker ========================"
Write-Host "4120 - Heartbeat and activation Port"
Write-Host "4122 - DSM Relay Port"
Write-Host "4119 - Managment Port"
Write-Host "========================================================================="
Write-Host "======== Starting Checks ========"

# Function to check if port is open
function Test-Port {
    param (
        [string]$target,
        [int]$port
    )
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    try {
        $tcpClient.Connect($target, $port)
        $tcpClient.Close()
        return $true
    }
    catch {
        return $false
    }
}

# Check if ports are open for the resolved IP address
foreach ($port in $ports) {
    $isOpen = Test-Port -target $ipAddress -port $port
    if ($isOpen) {
        Write-Host "Port $port is open on $target"
    } else {
        Write-Host "Port $port is closed on $target"
    }
}
