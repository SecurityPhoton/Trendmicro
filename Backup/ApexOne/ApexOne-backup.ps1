# Declaration of backup paths
$trendMicroPath = "C:\Program Files (x86)\Trend Micro\Apex One\PCCSRV\"
$destinationPath = "C:\backup"
$CertdestinationPath = "C:\backup\OfficeScanAuth.dat"
$DATdestinationPath = "C:\backup\Pccnt\Common"

# Checking if the backup target directory exists
if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

# Listing files and directories for backup
$itemsToBackup = @(
    "ofcscan.ini",
    "ous.ini",
    "Web\tmOPP",
    "Log",
    "Virus"
)

# Generate a string with the current time for the name of the zip file
$currentDateTime = (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")
$zipFileName = "TrendMicro-ApexOneBackup-$currentDateTime.zip"
$zipFilePath = Join-Path -Path $destinationPath -ChildPath $zipFileName

# Copy files and directories to the target directory
$tempFolderPath = Join-Path -Path $destinationPath -ChildPath "TempBackup-$currentDateTime"
New-Item -ItemType Directory -Path $tempFolderPath | Out-Null

foreach ($item in $itemsToBackup) {
    $sourcePath = Join-Path -Path $trendMicroPath -ChildPath $item
    Write-Host $sourcePath
    $targetPath = Join-Path -Path $tempFolderPath -ChildPath $item
    Copy-Item -Path $sourcePath -Destination $targetPath -Recurse -Force
}

Copy-Item -Path "C:\Program Files (x86)\Trend Micro\Apex One\AuthCertBackup\OfficeScanAuth.dat" -Destination $CertdestinationPath -Recurse -Force
Copy-Item -Path "C:\Program Files (x86)\Trend Micro\Apex One\PCCSRV\Pccnt\Common" -Destination $DATdestinationPath -Filter "OfcPfw**.dat" -Recurse -Force

# Creating a zip archive with backup copies
Compress-Archive -Path $tempFolderPath\*,$DATdestinationPath,$CertdestinationPath -DestinationPath $zipFilePath -Verbose

# Deleting a temporary directory with backup copies after creating an archive
Remove-Item -Path $tempFolderPath,$DATdestinationPath,$CertdestinationPath,"C:\backup\Pccnt" -Recurse -Force

# Display a message about the successful completion of the backup
Write-Output "Backup completed successfully. Saved as $zipFilePath"
