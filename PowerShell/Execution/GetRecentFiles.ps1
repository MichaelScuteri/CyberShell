function GetRecentFiles() { 

    Param(
        [String] $Hashtype
    )

    $recentfiles = Get-ChildItem -Path C:\Users\*\AppData\Roaming\Microsoft\Windows\Recent\* 

    foreach ($files in $recentfiles){

        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($files.FullName)

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
            Name = $files.Name
            Arguments = $arguments
            Description = $description
            TargetExists = $targetexists
            TargetFile = $targetfile
            WindowStyle = $shortcut.WindowStyle
        }
        Write-Output $Output
    }
}