function GetDomainComputers {

    [CmdletBinding()]
    Param ()
    begin {

    #Import nessecary module and run command to get all AD Computer info
    Import-Module -Name ActiveDirectory
    $Computers = Get-ADComputer -Filter * -Properties *

    #Loop through all AD computers found and grab required properties
    foreach( $Computer in $Computers ) {
        $ADComputer = New-Object PSObject -Property @{
            ComputerName =$Computer.Name
            SID = $Computer.SID
            DNSName = $Computer.DNSHostName
            CreatedTime = $Computer.Created.ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
            ModifiedTime = $Computer.Modified.ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
            AccessedTime = $Computer.LastLogonDate.ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss") 
            OSVersion = $Computer.OperatingSystemVersion
            OSServicePack = $Computer.OperatingSystemServicePack
            IPAddress = $Computer.IPv4Address
            PasswordNotRequired = ($Computer.PasswordNotRequired).ToString()
        }

        #Loop through all properties and remove $null and empty values
        foreach ($Property in $ADComputer.PsObject.Properties){
            if(($null -eq $Property.Value) -or ($Property.Value -eq "")){
                $Property.Value = "-"
            }
        }

        Write-Output $ADComputer
    }
}
}