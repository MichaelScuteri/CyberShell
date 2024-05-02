function GetStartupDirectories { 

    Param(
        [String] $Hashtype
    )

    $LnkFiles = Get-ChildItem -Path "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Filter *.lnk -Recurse

    foreach ($FileInfo in $LnkFiles){

        $Shell = New-Object -ComObject WScript.Shell
        $Shortcut = $Shell.CreateShortcut($FileInfo.FullName)

        $TargetFile = $Shortcut.TargetPath

        if (-not [string]::IsNullOrEmpty($TargetFile)) {
            $TargetExists = Test-Path -Path $TargetFile -PathType Leaf
        } else {
            $TargetFile = "-"
        }

        if([string]::IsNullOrEmpty($shortcut.Arguments)) {
            $Arguments = "-"
        }
        else{
            $Arguments = $Shortcut.Arguments
        }

        if([string]::IsNullOrEmpty($Shortcut.Description)) {
            $Description = "-"
        }
        else{
            $Description = $Shortcut.Description
        }

        $Output = New-Object PSObject -Property @{
            Name = $FileInfo.Name
            Arguments = $Arguments
            Description = $Description
            TargetExists = $TargetExists
            TargetFile = $TargetFile
            WindowStyle = $Shortcut.WindowStyle
        }
        Write-Output $Output    
    }
}