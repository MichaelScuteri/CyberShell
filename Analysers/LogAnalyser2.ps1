function LogAnalyser {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$true)]
        [String]$LogFile 
    )

    #read contents of log file 
    try { 
        $logEntries = Get-Content $LogFile -ErrorAction Stop
    } catch { 
        Write-Host "Log file not found. Please check path."
        exit
    }

    #hashtable to count IP occurences
    $IPCounts = @{}

    #loop through each log entry for invalid user IP
    foreach ($entry in $logEntries) {
        if ($entry -match "Invalid user.*from\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})") {
            $IP = $matches[1]
            if ($IPCounts.ContainsKey($IP)) {
                $IPCounts[$IP]++
            } else {
                $IPCounts[$IP] = 1
            }
        }
    }

    #enumerate through all IP's and their counts to get top 10 and sort
    $topIPs = $IPCounts.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 10

    $Output = @()
    foreach ($entry in $topIPs) {
        $Output += [PSCustomObject]@{
            IPAddress = $entry.Key
            Count     = $entry.Value
        }
    }

    $Output
}

LogAnalyser @args
