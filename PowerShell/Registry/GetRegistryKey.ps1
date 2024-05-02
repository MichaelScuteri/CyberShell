function GetRegistryKey {
    
    param (
        [String] $Path,
        [String] $Hive
    )

    $Path = $Path
    $SplitPath = $Path.Split("\") 
    $LastIndex = $SplitPath.Length - 1
    $Key = $SplitPath[-1]
    $Hive = $SplitPath[0]
    $Hive = $Hive.Replace(":", "")
    $RegPath = $SplitPath[0..($LastIndex - 1)] -Join "\"
    
    $KeyValue = Get-ItemPropertyValue -Path $RegPath -Name $Key

    $Output = New-Object PSObject -Property @{
        Key = $Key
        Value = $KeyValue
        Hive = $Hive
    }
    Write-Output $Output

}