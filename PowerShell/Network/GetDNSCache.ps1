function GetDNSCache {

    $dnscache = ipconfig /displaydns 

    foreach ($dns in $dnscache){

        if ($dns -match "Record Name") {
            $name = $dns.Split(":")[1].Trim()
        }

        if ($dns -match "Section") {
            $section = $dns.Split(":")[1].Trim()
        }

        if ($dns -match "Time To Live") {
            $TTL = $dns.Split(":")[1].Trim()
        }

        if ($dns -match "Data Length") {
            $length = $dns.Split(":")[1].Trim()
        }

        if ($dns -match "Time To Live") {
            $TTL = $dns.Split(":")[1].Trim()
        }

        if ($dns -match "\S\sRecord") {
            $address = $dns.Split(":", 2)[1].Trim()
        }
        
        if ($dns -match "Record Type") {
            $type = $dns.Split(":")[1].Trim()

            $type = switch ($type){
                1 {"A"}
                2 {"NS"}
                5 {"CNAME"}
                6 {"SOA"}
                12 {"PTR"}
                15 {"MX"}
                16 {"TXT"}
                28 {"AAAA"}
                default {"Unknown"}
            }
        
        

            $output = New-Object PSObject -Property @{
                Entry = $name
                RecordName = $name
                RecordType = $type
                Section = $section
                TTL = $ttl
                DataLength = $length
                Address = $address
            }
            Write-Output $output
        }
    }
}

