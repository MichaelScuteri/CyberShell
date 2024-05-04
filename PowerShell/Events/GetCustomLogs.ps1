function GetCustomLogs() {

    [CmdletBinding()]
    Param(
        [String] $LogName = "*",
        [String] $LogPath = "",
        [Int] $EventIDs,
        [String] $StartTime,
        [String] $EndTime,
        [Int] $MaxEvents = 2000,
        [Switch]$Help
    )

    #Start counter for events, to check if no events are found
    $OutputCount = 0

    if (!$StartTime -and !$EndTime){
        [datetime]$StartTime = (Get-Date).AddDays(-1)
        [datetime]$EndTime = (Get-Date)
    }

    #Error handling to guide user on what paramters are required, including -Help 
    if (!$EventIDs){
        if ($Help){
            ShowHelp
        }
        else {
            Write-Host "At minimum you must specify atleast one Event ID..."
            Write-Host "Example Usage:" 
            Write-Host "`tGetCustomLogs -EventIDs <id>"
        }
        $OutputCount += 1
    }

    else {
        #Main Command that is using parameters specified by user to search for events
        $GetLogs = Get-WinEvent -FilterHashtable @{

            LogName = $LogName; 
            Id = $EventIDs;
            Path = $LogPath;
            StartTime = $StartTime;
            EndTime = $EndTime

        } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
    }

    #Loop through each log entry for output
    foreach ($Log in $GetLogs){

        #Get log file path Location
        $GetLogPath = (Get-WinEvent -ListLog $Log.LogName).LogFilePath
        $GetLogPath = $GetLogPath -Replace ('%SystemRoot%', 'C:\Windows')
    
        $Output = New-Object PSObject -Property @{
            Message = $Log.Message
            EventTime = $Log.TimeCreated
            LogName = $Log.LogName
            LogPath = $GetLogPath
            EventID = $Log.Id
            LevelDisplayName = $Log.LevelDisplayName
            ActivityID = $Log.ActivityID
            KeywordDisplayName = $Log.KeywordsDisplayNames
        }

        #Loop through each property and replace null values with "-"
        foreach ($Property in $Output.PsObject.Properties){
            if(($null -eq $Property.Value) -or ($Property.Value -eq "")){
                $Property.Value = "-"
            }

        Write-Output $Output
        $OutputCount += 1

        }

    if ($OutputCount -eq 0){
        Write-Host "No Events Found"
    }
}
}
function ShowHelp() {
    Write-Host "Description:"
    Write-Host "`tDesigned to retrieve custom event logs based on specified parameters such as log name, 
    path, event IDs, and time range. It utilizes Get-WinEvent cmdlet to filter event logs and presents 
    the output in an organized format."
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "`tGetCustomLogs -LogName <log_name> -LogPath <log_path> -EventIDs <event_ids> [-StartTime <start_time>] [-EndTime <end_time>] [-MaxEvents <max_events>]"
    Write-Host ""
    Write-Host "Example Usage:"
    Write-Host "`tGetCustomLogs -LogName 'Application' -EventIDs 1001,1002 -StartTime '20/04/2024 12:00:00 AM' -EndTime '21/04/2024 12:00:00 AM'"
}

GetCustomLogs @args