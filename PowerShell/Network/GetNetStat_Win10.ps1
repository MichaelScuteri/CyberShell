function GetNetStat {
    
    $tcpConnections = Get-NetTCPConnection -State Established, TimeWait, CloseWait
    $udpConnections = Get-NetUDPEndpoint

    foreach ($tcpConnection in $tcpConnections) {
        $localAddress = $tcpConnection.LocalAddress
        $localPort = $tcpConnection.LocalPort
        $remoteAddress = $tcpConnection.RemoteAddress
        $remotePort = $tcpConnection.RemotePort
        $state = $tcpConnection.State
        $processID = $tcpConnection.OwningProcess
        $protocol = "TCP"
        $version = $localAddress

        if ($version -match '[:.]') {
            $version = if ($version -match ':') { "IPv6" } else { "IPv4" }
        } else {
            $version = "Unknown"
        }

        $output = New-Object PSObject -Property @{
            Protocol = $protocol
            Version = $version
            LocalAddress = $localAddress
            LocalPort = $localPort
            RemoteAddress = $remoteAddress
            RemotePort = $remotePort
            State = $state
            PID = $processID
        }
        Write-Output $output
    }

    foreach ($udpConnection in $udpConnections) {
        $localAddress = $udpConnection.LocalAddress
        $localPort = $udpConnection.LocalPort
        $remoteAddress = $udpConnection.RemoteAddress
        $remotePort = $udpConnection.RemotePort
        $state = $udpConnection.State
        $processID = $udpConnection.OwningProcess
        $protocol = "UDP"
        $version = $localAddress

        if ($version -match '[:.]') {
            $version = if ($version -match ':') { "IPv6" } else { "IPv4" }
        } else {
            $version = "Unknown"
        }
    
        $output = New-Object PSObject -Property @{
            Protocol = $protocol
            Version = $version
            LocalAddress = $localAddress
            LocalPort = $localPort
            RemoteAddress = $remoteAddress
            RemotePort = $remotePort
            State = $state
            PID = $processID
        }
        Write-Output $output
    }
}
