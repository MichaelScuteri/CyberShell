[CmdletBinding()]
    param (
        [Parameter(mandatory=$true)]
        [String]$ProcessName 
    )

$Processes = Get-Process 
$Found = $false 

foreach ($Process in $Processes) {
    if ($Process.Name -eq $ProcessName){
        $Found = $true
        try{
            $Process.Kill()
            Write-Host "$ProcessName killed"
        } 
        catch {
            Write-Host "$ProcessName could not be killed"
        }
    }
}

if ($Found -eq $false){
    Write-Host "Process not found"
}

