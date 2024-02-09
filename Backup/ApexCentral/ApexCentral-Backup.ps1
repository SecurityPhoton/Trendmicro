# Declaration of backup paths
$trendMicroPath = "C:\Program Files (x86)\Trend Micro"
$registryPath = "HKLM\Software\Wow6432Node\TrendMicro\TVCS"
$destinationPath = "C:\backup"

# Checking if the backup target directory exists
if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

# Listing files and directories for backup
$itemsToBackup = @(
    "CmKeyBackup",
    "Common\TMI\Profile",
    "Control Manager\ProductClass",
    "Control Manager\WebUI\Exports",
    "Control Manager\WebUI\WebApp\App_Data",
    "Control Manager\WebUI\download\dlp",
    "Control Manager\StringTable.xml",
    "Control Manager\ProductInfos.xml",
    "Control Manager\IDMapping.xml",
    "Control Manager\schema.dtd",
    "Control Manager\schema.xml"
)

# Generate a string with the current time for the name of the zip file
$currentDateTime = (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")
$zipFileName = "TrendMicroBackup-$currentDateTime.zip"
$zipFilePath = Join-Path -Path $destinationPath -ChildPath $zipFileName

# Export registry key
$regFile = Join-Path -Path $destinationPath -ChildPath "TrendMicroTVCS.reg"
& reg export $registryPath $regFile /y

# Copy files and directories to the target directory
$tempFolderPath = Join-Path -Path $destinationPath -ChildPath "TempBackup-$currentDateTime"
New-Item -ItemType Directory -Path $tempFolderPath | Out-Null

foreach ($item in $itemsToBackup) {
    $sourcePath = Join-Path -Path $trendMicroPath -ChildPath $item
    $targetPath = Join-Path -Path $tempFolderPath -ChildPath $item
    Copy-Item -Path $sourcePath -Destination $targetPath -Recurse -Force
}

# Creating a zip archive with backup copies
Compress-Archive -Path $tempFolderPath\*, $regFile -DestinationPath $zipFilePath -Verbose

# Deleting a temporary directory with backup copies after creating an archive
Remove-Item -Path $tempFolderPath -Recurse -Force
Remove-Item -Path $regFile -Recurse -Force

# Display a message about the successful completion of the backup
Write-Output "Backup completed successfully. Saved as $zipFilePath"
