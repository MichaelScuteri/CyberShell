function GetNetStat {
    
    $TCPConnections = Get-NetTCPConnection -State Established, TimeWait, CloseWait
    $UDPConnections = Get-NetUDPEndpoint

    foreach ($TCPConnection in $TCPConnections) {
        $LocalAddress = $TCPConnection.LocalAddress
        $LocalPort = $TCPConnection.LocalPort
        $RemoteAddress = $TCPConnection.RemoteAddress
        $RemotePort = $TCPConnection.RemotePort
        $State = $TCPConnection.State
        $ProcessID = $TCPConnection.OwningProcess
        $Protocol = "TCP"
        $Version = $LocalAddress

        if ($Version -Match '[:.]') {
            $Version = if ($Version -Match ':') { "IPv6" } else { "IPv4" }
        } else {
            $Version = "Unknown"
        }

        $output = New-Object PSObject -Property @{
            Protocol = $Protocol
            Version = $Version
            LocalAddress = $LocalAddress
            LocalPort = $LocalPort
            RemoteAddress = $RemoteAddress
            RemotePort = $RemotePort
            State = $State
            PID = $ProcessID
        }
        Write-Output $Output
    }

    foreach ($UDPConnection in $UDPConnections) {
        $LocalAddress = $UDPConnection.LocalAddress
        $LocalPort = $UDPConnection.LocalPort
        $RemoteAddress = $UDPConnection.RemoteAddress
        $RemotePort = $UDPConnection.RemotePort
        $State = $UDPConnection.State
        $ProcessID = $UDPConnection.OwningProcess
        $Protocol = "UDP"
        $Version = $LocalAddress

        if ($Version -Match '[:.]') {
            $Version = if ($Version -Match ':') { "IPv6" } else { "IPv4" }
        } else {
            $Version = "Unknown"
        }
    
        $Output = New-Object PSObject -Property @{
            Protocol = $Protocol
            Version = $Version
            LocalAddress = $LocalAddress
            LocalPort = $LocalPort
            RemoteAddress = $RemoteAddress
            RemotePort = $RemotePort
            State = $State
            PID = $ProcessID
        }
        Write-Output $Output
    }
}
