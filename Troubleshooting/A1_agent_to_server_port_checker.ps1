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
$ports = @(4343, 443, 8080, 80, 21112, 5274, 5274)

Write-Host "=============== Apex One Agent Checker ============================="
Write-Host "MCP agent uses ports 80 or 8080 and 443 or 4343 to connect to server"
Write-Host "5274 HTTP, 5274 HTTPS Web Rep Services Ports"
Write-Host "21112 Default port for Agent Server Connection"
Write-Host "===================================================================="
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
