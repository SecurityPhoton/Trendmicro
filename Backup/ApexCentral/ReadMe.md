# Trend Micro Apex Central On Prem Backup Script

This PowerShell script automates the backup of critical files and registry keys associated with Trend Micro Apex Central on-prem product.

## Prerequisites

- PowerShell  5.1 or higher
- Administrative privileges to access certain registry paths and backup locations

## Usage

1. Open PowerShell with administrative privileges.
2. Navigate to the directory containing the script.
3. Execute the script `.\ApexCental-Backup.ps1`.

The script will perform the following actions:

- Check if the backup target directory exists and create it if necessary.
- Export the specified registry key.
- Copy the listed files and directories to a temporary backup location.
- Compress the backup copies into a ZIP archive named with the current date and time.
- Delete the temporary backup copies and the registry export file.
- Output a message indicating the successful completion of the backup.

