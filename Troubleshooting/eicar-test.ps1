# Define the content for the EICAR test file
$eicarContent = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

# Get the current user's desktop path
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Set the path for the EICAR test file
$eicarFilePath = Join-Path -Path $desktopPath -ChildPath 'eicar.com'

# Create and write the EICAR test file
Set-Content -Path $eicarFilePath -Value $eicarContent -Encoding ASCII

# Attempt to run the EICAR test file (WARNING: This will trigger an antivirus response)
try {
    Start-Process -FilePath $eicarFilePath
} catch {
    Write-Host "An error occurred while trying to run the EICAR test file."
    Write-Host "Error details: $_"
}
