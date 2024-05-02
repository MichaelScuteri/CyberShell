function GetScheduledTasks { 

    $ScheduledTask = Get-ScheduledTask

    foreach ($Line in $ScheduledTask){

        $ScheduledTaskInfo = $Line | Get-ScheduledTaskInfo

        if ($ScheduledTaskInfo.NextRunTime) {
            $NextRunTask = $ScheduledTaskInfo.NextRunTime
        } else {
            $NextRunTask = "-"
        }

        $Output = New-Object PSObject -Property @{
            Name = $ScheduledTaskinfo.TaskName
            File = $FileInfo
            State = $Line.State
            Arguments = "-"
            CreatedBy = $Line.Author
            RunAs = $Line.Principal.UserId
            LastRun = $ScheduledTaskInfo.LastRunTime
            FirstRun = "-"
            NextRun = $NextRunTask
            DeleteAfterRun = "Bool" 
            } 
    Write-Output $Output
    }
}