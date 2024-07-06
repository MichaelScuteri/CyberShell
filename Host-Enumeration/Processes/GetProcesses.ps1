function GetProcesses { 
    [CmdletBinding()]
    param (
        [Int]$ProcessId = 0,
        [String]$ProcessName = "",
        [String]$Hashtype = "SHA256"
    )

    #Import GetFile
    . "C:\Users\micha\OneDrive\Documents\Code\PowerShell\Host-Enumeration\PowerShell\Files\GetFile.ps1"

    #if searching by PID
    if ($ProcessId -ne 0) {
        $ProcessList = Get-WmiObject -Class Win32_Process -Filter "ProcessId='$ProcessId'"
    }
    #if searching by process Name
    elseif ($ProcessName -ne ""){
        $ProcessList = Get-WmiObject -Class Win32_Process -Filter "Name='$ProcessName'"
    }
    #return all processes
    else {
        $ProcessList = Get-WmiObject -Class Win32_Process
    }    

    foreach ($Line in $ProcessList){
        $ParentProcess = Get-Process -Id $Line.ParentProcessId -ErrorAction SilentlyContinue
        $ParentName = if ($ParentProcess) { $ParentProcess.Name } else { "-" }

        try {
            $FileInfo = GetFile -Path $Line.Path -Hashtype $Hashtype 
        }
        catch {
            $FileInfo = "-"
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
            Path = $Line.Path
            CommandLine = $Line.CommandLine
            State = $State
            ParentPID = $Line.ParentProcessId
            ParentName = $ParentName
            CreationTime = $FileInfo.CreatedTime
            ModifiedTime = $FileInfo.ModifiedTime
            AccessedTime = $FileInfo.AccessedTime
            MemorySize =  $Line.WorkingSetSize
            HandleCount = $Line.HandleCount
            ThreadCount = $Line.ThreadCount
            Username = $Line.GetOwner().User
            Hash = $FileInfo.Hash.Value
            HashType = $FileInfo.Hash.Type
        }

        foreach ($Property in $Output.PsObject.Properties){
            if(($null -eq $Property.Value) -or ($Property.Value -eq "")){
                $Property.Value = "-"
            }
        }
    Write-Output $Output
    }
}

GetProcesses @args