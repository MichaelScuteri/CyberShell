function GetNetStat_Legacy {

    $GetNetstat = netstat -ano

    $Regex = '(?<Protocol>TCP|UDP)\s+(?<LocalAddr>\S*):(?<LocalPort>\d+)\s+(?<RemoteAddr>\S*):(?<RemotePort>\S+)\s+(?<State>\w+|)\s+(?<Pid>\d+)'

    foreach ($Line in $GetNetStat) {
        $List=[regex]::Matches($Line, $Regex)

        foreach ($Match in $List){
            $Protocol = $Match.Groups['Protocol'].Value
            $LocalAddress = $Match.Groups['LocalAddr'].Value
            $LocalPort = $Match.Groups['LocalPort'].Value
            $RemoteAddress = $Match.Groups['RemoteAddr'].Value
            $RemotePort = $Match.Groups['RemotePort'].Value
            $State = $Match.Groups['State'].Value
            $ProcID = $Match.Groups['Pid'].Value

            $ProcName = Get-Process -ID $ProcID
    
            if ($RemotePort -And $RemoteAddress -eq "*"){
                $RemoteAddress = $RemoteAddress -Replace ('\*','-')
                $RemotePort = $RemotePort -Replace ('\*','-')
            }

            if ($State -eq ''){
                $State = $State -Replace ('','-')
            }
    
            $Output = New-Object PSObject -Property @{
                Protocol = $Protocol
                LocalAddress = $LocalAddress
                LocalPort = $LocalPort
                RemoteAddress = $RemoteAddress
                RemotePort = $RemotePort
                State = $State
                PID = $ProcID
                Process = $ProcName.ProcessName
            }   
            Write-Output $Output
        }
    }
}

GetNetStat_Legacy
