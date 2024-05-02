function GetDnsCache{

    $GetDnsCache = Get-DnsClientCache

    foreach ($Dns in $GetDnsCache){

        $Name = $Dns.Name
        $Entry = $Dns.Entry
        $Type = $Dns.Type
        $TTL = $Dns.TTL
        $Section = $Dns.Section
        $DataLength = $Dns.DataLength
        $Address = $Dns.Data
        $Status = $Dns.Status

        $Type = Switch ($Dns.Type) {
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

        $Section = Switch ($Dns.Section) {
            1 {"Answer"}
            2 {"Authority"}
            3 {"Additional"}
            default {"Unknown"}
        }

        $Status = Switch ($Dns.Status) {
            0 {"Success"}
            1 {"NotExist"}
            2 {"NoRecords"}
            Default {"Unknown"}

        }

        $Output = New-Object PSObject -Property @{
            Entry = $Entry
            RecordName = $Name
            RecordType = $Type
            Section = $Section
            TTL = $TTL
            DataLength = $DataLength
            Address = $Address
            Status = $Status
            
        }
        Write-Output $Output
    }
}