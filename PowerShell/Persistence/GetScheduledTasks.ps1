function GetScheduledTasks { 

    $scheduledtask = Get-ScheduledTask
    $taskpath = "C:\Windows\System32\Tasks"

    foreach ($line in $scheduledtask){

        $scheduledtaskinfo = $line | Get-ScheduledTaskInfo

        if ($scheduledtaskinfo.NextRunTime) {
            $nextruntask = $scheduledtaskinfo.NextRunTime
        } else {
            $nextruntask = "-"
        }

        try{
            $fullpath = Join-Path -Path $taskpath -ChildPath "$($line.URI)"
            $fileinfo = GetFile -Path $fullpath
           
        }
        catch{
            $fileinfo = "-"
        }

        $Output = New-Object PSObject -Property @{
            Name = $scheduledtaskinfo.TaskName
            File = $fileinfo
            State = $line.State
            Arguments = "-"
            CreatedBy = $line.Author
            RunAs = $line.Principal.UserId
            CreatedTime = $fileinfo.CreatedTime
            LastRun = $scheduledtaskinfo.LastRunTime
            FirstRun = "-"
            NextRun = $nextruntask
            DeleteAfterRun = "Bool" 
            } | Select-Object $orderedProperties
    Write-Output $Output
    }
}