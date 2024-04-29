function GetARPCache {
    
    $arpcache = arp -a
    $arplines = $arpcache -split "\r?\n"

    $wmiarp = Get-WmiObject -Class Win32_IP4RouteTable

    $pattern = "\b(?<IPAddress>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<MAC>([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))\s+(?<Type>\w+)\b"

    foreach ($arp in $arplines){

        if (-not [string]::IsNullOrWhiteSpace($arp) -and $arp -match $pattern){
            $IPAddress = $matches["IPAddress"]
            $Type = $matches["Type"]
            $MAC = $matches["MAC"]
        }

        $interfaceInfo = $wmiarp | Where-Object { $_.Destination -eq $IPAddress } | Select-Object -First 1

        $Description = $interfaceInfo.Description
        $Index = $interfaceInfo.InterfaceIndex
        $Name = $interfaceInfo.Name


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




 