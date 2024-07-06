
function StopProcess {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [Int]$ProcessId
    )

    #Get process information from given parameter
    try {
        $TargetProcess = Get-Process -Id $ProcessId
    } 
    catch {
        throw "Failed as the process with ProcessId: $ProcessId, does not exist"
        break
    }

    $ProcessInfo = GetProcess -ProcessID $ProcessId

    #Duplicate the process so it can still be used after termination
    $DuplicateTargetProcess = $TargetProcess

    #Kill specified process
    try {
        taskkill /F /PID $ProcessId | Out-Null
    } 
    catch {
        throw "Failed to kill process with ProcessId: $ProcessId"
    }

    #Check if it has been killed
    if ($DuplicateTargetProcess.HasExited -eq $True) {
        $Status = 'Success'
    } 
    else {
        $Status = 'Failed'
    }

    $null = $DuplicateTargetProcess

    $ProcessInfo = GetProcesses -ProcessId $ProcessId

    $StopProc = New-Object -TypeName PSObject -Property @{
        Process = $ProcessInfo
        Status = $Status
    } 
    Write-Output $StopProc
}