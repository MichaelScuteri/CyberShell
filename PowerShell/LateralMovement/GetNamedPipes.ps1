function GetNamedPipes { 

    $pipes = [System.IO.Directory]::GetFiles("\\.\\pipe\\")


    foreach ($line in $pipes){
        $line = $line.Replace("\\.\\pipe\\", "")

        $Output = New-Object PSObject -Property @{
            Name = $line
            }
            
    Write-Output $Output
    }
}
