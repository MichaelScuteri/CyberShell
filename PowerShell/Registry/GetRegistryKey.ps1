function GetRegistryKeys {
    param (
        [string]$Path
    )

    #Get all keys and values at the current path
    $Location = Get-Item -Path $Path
    $Values = $Location.GetValueNames()
    
    # Output values at the current path
    foreach ($Key in $Values) {
        $Data = $Location.GetValue($Key)
    
        $Output = New-Object PSObject -Property @{
            Key = $Key
            Value = $Data
        }
    Write-Output $Output
    }

    #Get all subkeys and call the function recursively
    $SubKeys = $Location.GetSubKeyNames()
    foreach ($SubKey in $SubKeys) {
        $SubPath = "$Path\$SubKey"
        GetRegistryKeys -Path $SubPath
    }
}

GetRegistryKeys @args
