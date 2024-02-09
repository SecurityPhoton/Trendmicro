# Trend Micro Apex One Backup Script
It is additional tool for backup and does not replace OsceMigrate tool!
This PowerShell script is designed to automate the backup process for Trend Micro Apex One by copying specific files and directories, as well as a registry key, to a designated backup location. The script then archives these files into a single ZIP file with the current date and time in the filename.

## Features

- Backs up selected files and directories from the Trend Micro Apex One installation directory.
- Creates a ZIP archive with the current date and time appended to the filename.
- Provides progress updates during execution.

## Prerequisites

- Administrative rights to access the files and folders being backed up.
- The `Compress-Archive` cmdlet is available in PowerShell version  5.0 and later.

## Instructions

1. Open PowerShell with administrative privileges.
2. Navigate to the directory containing the script.
3. Execute the script by typing `.\Backup-TrendMicroApexOne.ps1` and pressing Enter.

## Backup Details

The script backs up the following items:

- Configuration files: `ofcscan.ini`, `ous.ini`
- Web protection settings: `Web\tmOPP`
- Log files: `Log`
- Virus definitions: `Virus`
- Authentication certificate: `OfficeScanAuth.dat`
- Firewall settings: `Pccnt\Common\OfcPfw*.dat`

## Output

After the script completes, a ZIP file named `TrendMicro-ApexOneBackup-[DATE-TIME].zip` will be created in the `C:\backup` directory.

## Notes

- The script automatically creates the backup directory if it does not exist.
- After archiving, the temporary backup directory and its contents are removed.
- Always ensure that the paths specified in the script match the actual locations of the files and folders on your system.

## Example Usage

powershell .\Backup-TrendMicroApexOne.ps1

---

This script is intended for use on Windows systems and assumes that the user has the necessary permissions to access the files and directories mentioned. Always test scripts in a controlled environment before deploying them in a production setting.
