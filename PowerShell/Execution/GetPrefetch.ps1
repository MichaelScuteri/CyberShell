function GetPrefetch() { 

    Param(
        [String] $Hashtype
    )

    #Get Prefetch path and filter for .pf files
    $PrefetchPath = Get-ChildItem -Path C:\Windows\Prefetch -Recurse -Filter *.pf

    foreach ($File in $PrefetchPath){
        $FileInfo = GetFile -path $file.FullName
        $Name = $File.BaseName
        $Hash = Get-FileHash $Name 

        $Output = New-Object PSObject -Property @{
            PrefetchName = $Name
            PrefetchHash = $Hash
            LastExecuted = $FileInfo
        }
        
        #Loop through each property and replace null values with "-"
        foreach ($Property in $Output.PsObject.Properties){
            if(($null -eq $Property.Value) -or ($Property.Value -eq "")){
                $Property.Value = "-"
            }
    Write-Output $Output
    }
}
}