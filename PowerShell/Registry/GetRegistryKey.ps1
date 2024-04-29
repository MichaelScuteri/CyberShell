function GetRegistryKey {
    
    param (
        [String] $Path,
        [String] $Hive
    )

    $path = $Path
    $splitPath = $Path.Split("\") 
    $lastIndex = $splitPath.Length - 1
    $key = $splitPath[-1]
    $hive = $splitPath[0]
    $hive = $hive.Replace(":", "")
    $regpath = $splitpath[0..($lastIndex - 1)] -join "\"
    
    $keyvalue = Get-ItemPropertyValue -Path $regpath -Name $key

    $Output = New-Object PSObject -Property @{
        Key = $key
        Value = $keyvalue
        Hive = $hive
    }
    Write-Output $Output

}