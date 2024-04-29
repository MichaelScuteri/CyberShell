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

    foreach ($line in $ProcessList){

        $starttime = get-date($line.converttodatetime($line.CreationDate)) -Format "yyyy-mm-dd hh:mm:ss"
        
        $ParentProcess = Get-Process -Id $line.ParentProcessId -ErrorAction SilentlyContinue
        $ParentName = if ($ParentProcess) { $ParentProcess.Name } else { "-" }

        try {
            $fileinfo = GetFile -Path $line.FullName 
        } 
        catch {
            $fileinfo = "-"
        }

        try {
            $cmdline = $line.CommandLine
        }
        catch{
            $cmdline = "-"
        }

        $GetProcessStatus = Get-Process | Where-Object {$_.id -eq $line.ProcessId}

        if ($GetProcessStatus.HasExited){
            $state = "Exited"
        }
        else {
            $state = "Running"
        }

        $Output = New-Object PSObject -Property @{
            PID = $line.ProcessId
            Name = $line.ProcessName
            CommandLine = $cmdline
            State = $state
            ParentPID = $line.ParentProcessId
            ParentName = $ParentName
            CreationTime = $starttime
            Image = $fileinfo.Path
            MemorySize =  $line.WorkingSetSize
            HandleCount = $line.HandleCount
            HandleList = "-"
            ThreadCount = $line.ThreadCount
            Username = $line.GetOwner().User
        }
    Write-Output $Output
    }
}