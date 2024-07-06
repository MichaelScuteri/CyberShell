function GetPrefetch() { 

    Param(
        [String] $Hashtype
    )

    #Import GetFile
    . "C:\Users\micha\OneDrive\Documents\Code\Host-Enumeration\PowerShell\Files\GetFile.ps1"

    #Get Prefetch path and filter for .pf files
    $PrefetchPath = Get-ChildItem -Path C:\Windows\Prefetch -Recurse -Filter *.pf

    foreach ($File in $PrefetchPath){
        $FileInfo = GetFile -Path $File.FullName
        $Name = $File.BaseName

        $Output = New-Object PSObject -Property @{
            Name = $Name
            FileInfo = $FileInfo
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

GetPrefetch @args