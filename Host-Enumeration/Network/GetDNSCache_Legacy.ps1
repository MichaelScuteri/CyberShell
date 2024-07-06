function GetDnsCache_Legacy {

    $DnsCache = ipconfig /displaydns 

    foreach ($Dns in $DnsCache){

        if ($Dns -Match "Record Name") {
            $Name = $Dns.Split(":")[1].Trim()
        }

        if ($Dns -Match "Section") {
            $Section = $Dns.Split(":")[1].Trim()
        }

        if ($Dns -Match "Time To Live") {
            $TTL = $Dns.Split(":")[1].Trim()
        }

        if ($Dns -Match "Data Length") {
            $Length = $Dns.Split(":")[1].Trim()
        }

        if ($Dns -Match "Time To Live") {
            $TTL = $Dns.Split(":")[1].Trim()
        }

        if ($Dns -Match "\S\sRecord") {
            $Address = $Dns.Split(":", 2)[1].Trim()
        }
        
        if ($Dns -Match "Record Type") {
            $Type = $Dns.Split(":")[1].Trim()

            $Type = switch ($Type){
                1 {"A"}
                2 {"NS"}
                5 {"CNAME"}
                6 {"SOA"}
                12 {"PTR"}
                15 {"MX"}
                16 {"TXT"}
                28 {"AAAA"}
                Default {"Unknown"}
            }

            $Output = New-Object PSObject -Property @{
                Entry = $Name
                RecordName = $Name
                RecordType = $Type
                Section = $Section
                TTL = $TTL
                DataLength = $Length
                Address = $Address
            }
            Write-Output $Output
        }
    }
}

GetDnsCache_Legacy
