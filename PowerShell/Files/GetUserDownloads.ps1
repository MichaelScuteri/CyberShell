function GetUserDownloads { 

    param (
        [String] $Hashtype,
        [int] $Maxsize = 0
    )

    $files = Get-ChildItem -Path C:\USERS\*\DOWNLOADS -Recurse

    foreach ($file in $files){
        if ($Maxsize -ne 0 -and $file.Length -gt $Maxsize){
            continue 
        }

        if ($Hashtype -ne ""){
            $fileinfo = GetFile -Path $file.FullName -Hashtype $Hashtype
        }
        else {
            $fileinfo = GetFile -Path $file.FullName
        }
    
        $Output = New-Object PSObject -Property @{
            Name = $fileinfo.Name
            Path = $fileinfo.Path
            Hash = $fileinfo.Hash
            Permissions = $fileinfo.Permissions
            Owner = $fileinfo.Owner
            Group = "-"
            Size = $fileinfo.Size
            CreatedTime = $fileinfo.CreatedTime
            AccessedTime = $fileinfo.AccessedTime
            ModifiedTime = $fileinfo.ModifiedTime
            VersionInfo = $fileinfo.VersionInfo

        }
        Write-Output $Output
    }
}
