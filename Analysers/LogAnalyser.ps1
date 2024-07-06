function LogAnalyser{
    [CmdletBinding()]
        param (
            [Parameter(mandatory=$true)]
            [String]$LogFile 
        )

    # Read contents of log file 
    try { 
        $logEntries = Get-Content $LogFile -ErrorAction Stop
    } catch { 
        Write-Host "Log file not found. Please check path."
        exit
    }

    # Initialize a counter for suspicious activity
    $suspiciousActivityCount = 0
    # Initialize an ArrayList to store unique invalid username attempts
    $usernames = New-Object System.Collections.ArrayList

    # Loop through each log entry in the file
    foreach ($entry in $logEntries) {
        if ($entry -match "input_userauth_request") {
            $suspiciousActivityCount++
            $substrings = $entry -split '\s+'
            $username = $substrings[-2] }
            if (-not $usernames.contains($username)) {
                $usernames.add($username) > $null
            }

            $Output = [PSCustomObject]@{
                SuspiciousActivityCount = $suspiciousActivityCount
                UniqueUsers = $usernames.Count
            }
        }

    Write-Output $output
}

LogAnalyser @args