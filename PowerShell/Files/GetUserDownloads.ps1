function GetUserDownloads { 

    param (
        [String] $Hashtype = "SHA256",
        [int] $Maxsize = 0
    )

    #Import GetFile
    . "C:\Users\micha\OneDrive\Documents\Code\Host-Enumeration\PowerShell\Files\GetFile.ps1"

    #Get all users downloads directories
    $Files = Get-ChildItem -Path C:\USERS\*\DOWNLOADS -Recurse

    #Loop through all files and allow to specify max size
    foreach ($File in $Files){
        if ($Maxsize -ne 0 -and $File.Length -gt $Maxsize){
            continue 
        }

        $FileInfo = GetFile -Path $File.FullName -Hashtype $Hashtype
    
        $Output = New-Object PSObject -Property @{
            Name = $FileInfo.Name
            Path = $FileInfo.Path
            Hash = $FileInfo.Hash.Value
            HashType = $FileInfo.Hash.Type
            Permissions = $FileInfo.Permissions
            Owner = $FileInfo.Owner
            Group = "-"
            Size = $FileInfo.Size
            CreatedTime = $FileInfo.CreatedTime
            AccessedTime = $FileInfo.AccessedTime
            ModifiedTime = $FileInfo.ModifiedTime
            VersionInfo = $FileInfo.VersionInfo
        }
        Write-Output $Output
    }
}

GetUserDownloads @args
