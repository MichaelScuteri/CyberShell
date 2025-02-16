$ComputersList = "C:\Installers\Splunk\computers.txt" 
$InstallerPath = "C:\Installers\Splunk\splunkforwarder-9.2.1.msi" 
$InstallCommand = "/i splunkforwarder-9.2.1.msi /quiet" 

$Computers = Get-Content -Path $ComputersList

#install Splunk Forwarder on a remote computer
function Install-Splunk {
    param (
        [string]$Computer
    )

    #copy the installer to the remote computer
    Copy-Item -Path $InstallerPath -Destination "\\$Computer\C$\Temp" -Force -ErrorAction Stop

    #execute the installer on the remote computer
    Invoke-Command -ComputerName $Computer -ScriptBlock {
        Start-Process -FilePath "msiexec.exe" -ArgumentList $InstallCommand -Wait
    } -ErrorAction Stop
}

#loop over each computer and install Splunk Forwarder
foreach ($Computer in $Computers) {
    try {
        Write-Output "Installing Splunk Forwarder on $Computer..."
        Install-Splunk -computer $Computer
        Write-Output "Installation completed on $Computer."
    } catch {
        Write-Error "Failed to install Splunk Forwarder on $Computer. Error: $_"
    }
}
