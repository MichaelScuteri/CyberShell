function GetRecentFiles() { 

    Param(
        [String] $Hashtype
    )

    $RecentFiles = Get-ChildItem -Path C:\Users\*\AppData\Roaming\Microsoft\Windows\Recent\* 

    foreach ($Files in $RecentFiles){

        $Shell = New-Object -ComObject WScript.Shell
        $Shortcut = $Shell.CreateShortcut($Files.FullName)

        $TargetFile = $Shortcut.TargetPath

        if (-not [String]::IsNullOrEmpty($TargetFile)) {
            $TargetExists = Test-Path -Path $TargetFile -PathType Leaf
        } else {
            $TargetFile = "-"
        }

        if([String]::IsNullOrEmpty($Shortcut.Arguments)) {
            $Arguments = "-"
        }
        else{
            $Arguments = $Shortcut.Arguments
        }

        if([String]::IsNullOrEmpty($Shortcut.Description)) {
            $Description = "-"
        }
        else{
            $Description = $Shortcut.Description
        }


        $Output = New-Object PSObject -Property @{
            Name = $Files.Name
            Arguments = $Arguments
            Description = $Description
            TargetExists = $Targetexists
            TargetFile = $TargetFile
            WindowStyle = $Shortcut.WindowStyle
        }
        Write-Output $Output
    }
}