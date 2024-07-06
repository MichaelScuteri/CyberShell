function GetArpCache {
    
    $ArpCache = Arp -a
    $ArpLines = $ArpCache -Split "\r?\n"

    $WmiArp = Get-WmiObject -Class Win32_IP4RouteTable

    $Pattern = "\b(?<IPAddress>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<MAC>([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))\s+(?<Type>\w+)\b"

    foreach ($Arp in $ArpLines){

        if (-not [String]::IsNullOrWhiteSpace($Arp) -and $Arp -match $Pattern){
            $IPAddress = $Matches["IPAddress"]
            $Type = $Matches["Type"]
            $MAC = $Matches["MAC"]
        }

        $InterfaceInfo = $WmiArp | Where-Object { $_.Destination -eq $IPAddress } | Select-Object -First 1

        $Description = $InterfaceInfo.Description
        $Index = $InterfaceInfo.InterfaceIndex
        $Name = $InterfaceInfo.Name


        $Output = New-Object PSObject -Property @{
            Name = $Name
            Type = $Type
            Description = $Description
            MAC = $MAC
            ServiceName = "-"
            AdapterIndex = $Index
            IPAddress = $IPAddress
        }
        Write-Output $Output
    }
}




 