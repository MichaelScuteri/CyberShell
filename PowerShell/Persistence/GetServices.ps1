function GetServices { 

    #$services = Get-Service
    $win32service = Get-WmiObject -Class Win32_Service

    foreach ($line in $win32service){

        $ServPath = $line.PathName.Split(' ', 2)

        try{
            $fileinfo = (GetFile -path $ServPath[0]).Path
        }
        catch{
            $fileinfo = "-"
        }

        try{
            $createdtime = (GetFile -path $ServPath[0]).CreatedTime
        }
        catch{
            $createdtime = "-"
        }

        try{
            $startedtime = (GetFile -path $ServPath[0]).AccessedTime
        }
        catch{
            $startedtime = "-"
        }

        if ($line.Startname){
            $startname = $line.Startname
        }
        else{
            $startname = "-"
        }


            $Output = New-Object PSObject -Property @{
                Name = $line.Name
                CommandLine = $line.PathName
                File = $fileinfo
                State = $line.State
                Exitcode = $line.Exitcode
                StartedTime = $startedtime
                CreatedTime = $createdtime
                Interactive = $line.DesktopInteract
                Description = $line.Description
                PID = $line.ProcessId
                CreatedBy = $startname
            }
    Write-Output $Output
    }
}