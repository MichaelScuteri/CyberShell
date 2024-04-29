function GetPrefetch() { 

    Param(
        [String] $Hashtype
    )

    $prefetchpath = Get-ChildItem -Path C:\Windows\Prefetch -Recurse -Filter *.pf

    foreach ($file in $prefetchpath){

        $fileinfo = GetFile -path $file.FullName
        $name = $file.BaseName
        $hash = Get-FileHash $name 

        $Output = New-Object PSObject -Property @{
            PrefetchName = $name
            PrefetchHash = $hash
            LastExecuted = $fileinfo
            
        }
        Write-Output $Output
    }

}