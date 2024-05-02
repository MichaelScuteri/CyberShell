function GetProcesses { 
    param (
        [int] $ProcessID,
        [String] $ProcessName,
        [String] $Hashtype
    )

    #if searching by PID
    if ($ProcessID -ne 0) {
        $ProcessList = Get-WmiObject -Class Win32_Process -Filter "ProcessId='$ProcessID'"
    }
    #if searching by process Name
    if ($ProcessName -ne ""){
        $ProcessList = Get-WmiObject -Class Win32_Process -Filter "Name='$ProcessName'"
    }
    #return all processes
    else {
        $ProcessList = Get-WmiObject -Class Win32_Process
    }    

    foreach ($Line in $ProcessList){

        $StartTime = Get-Date($Line.ConvertToDateTime($Line.CreationDate)) -Format "yyyy-mm-dd hh:mm:ss"
        
        $ParentProcess = Get-Process -Id $Line.ParentProcessId -ErrorAction SilentlyContinue
        $ParentName = if ($ParentProcess) { $ParentProcess.Name } else { "-" }

        try {
            $CmdLine = $Line.CommandLine
        }
        catch{
            $CmdLine = "-"
        }

        $GetProcessStatus = Get-Process | Where-Object {$_.id -eq $Line.ProcessId}

        if ($GetProcessStatus.HasExited){
            $State = "Exited"
        }
        else {
            $State = "Running"
        }

        $Output = New-Object PSObject -Property @{
            PID = $Line.ProcessId
            Name = $Line.ProcessName
            CommandLine = $CmdLine
            State = $state
            ParentPID = $Line.ParentProcessId
            ParentName = $ParentName
            CreationTime = $StartTime
            MemorySize =  $Line.WorkingSetSize
            HandleCount = $Line.HandleCount
            HandleList = "-"
            ThreadCount = $Line.ThreadCount
            Username = $Line.GetOwner().User
        }
    Write-Output $Output
    }
}