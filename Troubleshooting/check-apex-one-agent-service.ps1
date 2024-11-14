# List of services to check
$services = @(
    "Trend Micro Vulnerability Protection Service (Agent)",
    "Trend Micro Unauthorized Change Prevention Service",
    "Apex One NT Listener",
    "Apex One NT RealTime Scan",
    "Apex One NT WSC Service",
    "Trend Micro Endpoint Basecamp",
    "Trend Micro Cloud Endpoint Telemetry Service",
    "Trend Micro Web Service Communicator",
    "Cloud Endpoint Service"

)

# Loop through each service and check its status
foreach ($service in $services) {
    # Get the service object
    $serviceObject = Get-Service -Name $service -ErrorAction SilentlyContinue

    if ($serviceObject) {
        # Check if the service is running and enabled
        $status = $serviceObject.Status
        $startupType = (Get-WmiObject -Query "SELECT StartMode FROM Win32_Service WHERE Name='$($serviceObject.Name)'").StartMode

        # Output results
        Write-Host "Service: $service"
        Write-Host "  Status: $status"
        Write-Host "  Startup Type: $startupType"
        Write-Host "-------------------------"
    } else {
        Write-Host "Service: $service - Not found"
        Write-Host "-------------------------"
    }
}
