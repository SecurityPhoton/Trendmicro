# Script to clean IIS access logs older then X days.
# Add it to sheduller to run automatically.
$LogPath = "C:\inetpub\logs"
# Change the days var to comply your needs.
$maxDaystoKeep = -10
$outputPath = "c:\Cleanup_Old_IIS.log"
$itemsToDelete = dir $LogPath -Recurse -File *.log | Where LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep)) 

if ($itemsToDelete.Count -gt 0)
{
    ForEach ($item in $itemsToDelete)
    {
        "$($item.BaseName) is older than $((get-date).AddDays($maxDaystoKeep)) and will be deleted" | Add-Content $outputPath
        Get-item $item.FullName | Remove-Item -Verbose
    }
}
ELSE
{
    "No items to be deleted today $($(Get-Date).DateTime)"  | Add-Content $outputPath
}
 
Write-Output "Cleanup of IIS log files older than $((get-date).AddDays($maxDaystoKeep)) completed..."
start-sleep -Seconds 5
