function GetServices { 

    #$services = Get-Service
    $Win32Service = Get-WmiObject -Class Win32_Service

    foreach ($Line in $win32service){

        if ($Line.Startname){
            $StartName = $Line.Startname
        }
        else{
            $StartName = "-"
        }

            $Output = New-Object PSObject -Property @{
                Name = $Line.Name
                CommandLine = $Line.PathName
                State = $Line.State
                Exitcode = $Line.Exitcode
                Interactive = $Line.DesktopInteract
                Description = $Line.Description
                PID = $Line.ProcessId
                CreatedBy = $Startname
            }

    Write-Output $Output
    
    }
}