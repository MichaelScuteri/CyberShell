function GetStartupDirectories() { 

    Param(
        [String] $Hashtype
    )

    $lnkfiles = Get-ChildItem -Path "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Filter *.lnk -Recurse
    $notlnk = Get-ChildItem -Path "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Exclude *.lnk -Recurse

    foreach ($fileinfos in $lnkfiles){

        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($fileinfos.FullName)

        $targetfile = $shortcut.TargetPath

        if (-not [string]::IsNullOrEmpty($targetfile)) {
            $targetexists = Test-Path -Path $targetfile -PathType Leaf
        } else {
            $targetfile = "-"
        }

        if([string]::IsNullOrEmpty($shortcut.Arguments)) {
            $arguments = "-"
        }
        else{
            $arguments = $shortcut.Arguments
        }

        if([string]::IsNullOrEmpty($shortcut.Description)) {
            $description = "-"
        }
        else{
            $description = $shortcut.Description
        }

        $Output = New-Object PSObject -Property @{
            Name = $fileinfos.Name
            Arguments = $arguments
            Description = $description
            TargetExists = $targetexists
            TargetFile = $targetfile
            WindowStyle = $shortcut.WindowStyle
        }
        Write-Output $Output    
    }

    foreach ($otherfiles in $notlnk){

        $fileinfo = Get-File -Path $otherfiles
        
        $Output = New-Object PSObject -Property @{
            Name = $fileinfo.Name
            Path = $fileinfo.Path
            Hash = $fileinfo.Hash
            Permissions = $fileinfo.Permissions
            Owner = $fileinfo.Owner
            Group = $fileinfo.Group
            Size = $fileinfo.Size
            CreatedTime = $fileinfo.CreationTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
            AccessedTime = $fileinfo.LastAccessTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
            ModifiedTime = $fileinfo.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
            VersionInfo = $fileinfo.VersionInfo
        }
        Write-Output $Output
    }
}