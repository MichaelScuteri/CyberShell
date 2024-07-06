function GetBasicInformation { 

    $WindowsVersion = (Get-WmiObject -Class Win32_OperatingSystem)
    $PatchVersion = (Get-WmiObject -Class Win32_QuickFixEngineering)
    if (!$PatchVersion) {
        $PatchVersion = "-"
    }

    $OutputObject = New-Object PSObject -Property @{
        OSVersion = $($WindowsVersion.Caption -join $WindowsVersion.Version)
        OSArchitecture = $($env:PROCESSOR_ARCHITECTURE)
        OSServicePack = "-"
        PowershellVersion = $PSVersionTable.PSVersion.Major
        TimeZone = [System.TimeZone]::CurrentTimeZone.StandardName
        Patches = $PatchVersion
    }
    Write-Output $OutputObject
}