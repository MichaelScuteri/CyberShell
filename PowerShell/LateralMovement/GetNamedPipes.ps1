function GetNamedPipes { 

    $Pipes = [System.IO.Directory]::GetFiles("\\.\\pipe\\")


    foreach ($Line in $Pipes){
        $Line = $Line.Replace("\\.\\pipe\\", "")

        $Output = New-Object PSObject -Property @{
            Name = $Line
            }
            
    Write-Output $Output
    }
}
