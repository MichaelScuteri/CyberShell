function GetNetStat {

$getnetstat = netstat -ano
$lines = $getnetstat -split '\r?\n'

foreach ($line in $lines) {

    $fields = $line -split '\s+|:\d'

    if ($fields) {

        $protocol = $fields[1]
        $localAddress = $fields[2]
        $localport = $fields[3]
        $foreignAddress = $fields[4]
        $remoteport = $fields[5]
        $state = $fields[6] 
        $processid = $fields[7]
        
        }

    $output = New-Object PSObject -Property @{

        Protocol = $protocol
        LocalAddress = $localAddress
        LocalPort = $localPort
        ForeignAddress = $foreignAddress
        RemotePort = $remoteport
        State = $state
        PID = $processid
        }
    Write-Output $output
    }
}
