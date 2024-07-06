function GetStartupDirectories() { 

    Param(
        [String] $Hashtype = "SHA256"
    )

    #Import GetFile
    . "C:\Users\micha\OneDrive\Documents\Code\Host-Enumeration\PowerShell\Files\GetFile.ps1"

    #Get all .lnk files and .exe's for all users in startup directory
    $LnkFiles = Get-ChildItem -Path "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Start-up" -Filter *.lnk -Recurse
    $NotLnk = Get-ChildItem -Path "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Start-up" -Exclude *.lnk -Recurse

    foreach ($FileInfo in $LnkFiles){
        #Create Shell object to access .lnk file information
        $Shell = New-Object -ComObject WScript.Shell
        $Shortcut = $Shell.CreateShortcut($FileInfo.FullName)

        $TargetFile = $Shortcut.TargetPath

        if (-not [string]::IsNullOrEmpty($TargetFile)) {
            $TargetExists = Test-Path -Path $TargetFile -PathType Leaf
        } else {
            $TargetFile = "-"
        }


        $LnkOutput = New-Object PSObject -Property @{
            Name = $FileInfo.Name
            Arguments = $Shortcut.Arguments
            Description = $Shortcut.Description
            TargetExists = $TargetExists
            TargetFile = $TargetFile
            WindowStyle = $Shortcut.WindowStyle
        }

        foreach ($Property in $LnkOutput.PsObject.Properties){
            if(($null -eq $Property.Value) -or ($Property.Value -eq "")){
                $Property.Value = "-"
            }
        }
        Write-Output $LnkOutput    
    }

    foreach ($OtherFiles in $NotLnk){

        $FileInfo = GetFile -Path $OtherFiles.FullName
        
        if ($null -eq $FileInfo) {
            $FileOutput = New-Object PSObject -Property @{
                Name = $FileInfo.Name
                Path = $FileInfo.Path
                Hash = $FileInfo.Hash.Value
                HashType = $FileInfo.HashType.Value
                Permissions = $FileInfo.Permissions
                Owner = $FileInfo.Owner
                Group = $FileInfo.Group
                Size = $FileInfo.Size
                CreatedTime = $FileInfo.CreationTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
                AccessedTime = $FileInfo.LastAccessTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
                ModifiedTime = $FileInfo.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
                VersionInfo = $FileInfo.VersionInfo
            }
            Write-Output $FileOutput
        }
    }
}

GetStartupDirectories @args