function GetDNSCache_Win10{

    $getdnscache = Get-DNSClientCache

    foreach ($dns in $getdnscache){

        $name = $dns.Name
        $entry = $dns.Entry
        $type = $dns.Type
        $ttl = $dns.TTL
        $section = $dns.Section
        $datalength = $dns.DataLength
        $address = $dns.Data
        $status = $dns.Status

        $type = switch ($dns.Type) {
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

        $section = switch ($dns.Section) {
            1 {"Answer"}
            2 {"Authority"}
            3 {"Additional"}
            default {"Unknown"}
        }

        $status = switch ($dns.Status) {
            0 {"Success"}
            1 {"NotExist"}
            2 {"NoRecords"}
            default {"Unknown"}

        }

        $output = New-Object PSObject -Property @{
            Entry = $entry
            RecordName = $name
            RecordType = $type
            Section = $section
            TTL = $ttl
            DataLength = $datalength
            Address = $address
            Status = $status
            
        }
        Write-Output $output
    }
}