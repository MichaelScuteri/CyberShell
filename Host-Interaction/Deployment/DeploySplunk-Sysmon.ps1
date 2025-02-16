$ComputersList = 'C:\Installers\Splunk\computers.txt' 
$SplunkInstallerPath = 'C:\Installers\Splunk\splunkforwarder-9.2.1.msi'
$SysmonInstallerPath = 'C:\Installers\Sysmon\sysmon64.exe'
$SplunkInstallCommand = '/i c:\temp\splunkforwarder-9.2.1.msi AGREETOLICENSE=Yes RECEIVING_INDEXER="172.16.30.10:9997" LAUNCHSPLUNK=1 SPLUNKUSERNAME=admin SPLUNKPASSWORD=Password1' 
$SysmonInstallCommand = '-accepteula -i c:\temp\sysmon_config'

$Computers = Get-Content -Path $ComputersList

#install Splunk Forwarder on a remote computer
function Install-Splunk {
    param (
        [string]$Computer
    )

    #copy the installer to the remote computer
    Copy-Item -Path $SplunkInstallerPath -Destination "\\$Computer\C$\temp\" -Force -ErrorAction Stop
    Write-Output "Splunk forwarder copied to $Computer"

    #execute the installer on the remote computer
    Invoke-Command -ComputerName $Computer -ScriptBlock {
        #Copy-Item -Path "C:\Temp\inputs.conf" -Diestination "\\$Computer\C$\Temp" -Force -ErrorAction Stop
        Start-Process -FilePath "msiexec.exe" -ArgumentList $SplunkInstallCommand
        Stop-Service SplunkForwarder
        Write-Output "Splunk forwarder installed to $Computer"

        #Copy-Item -Path "C:\Installers\Splunk\inputs.conf" -Destination "\\$Computer\C$\Program Files\SplunkUniversalForwarder\etc\system\local"
        #Write-Output "inputs.conf copied to $Computer"
        Start-Service SplunkForwarder
    } -ErrorAction Stop
}

#install sysmon on a remote computer
function Install-Sysmon {
    param (
        [string]$Computer
    )

    #copy the installer to the remote computer
    Copy-Item -Path $SysmonInstallerPath -Destination "\\$Computer\C$\Temp" -Force -ErrorAction Stop
    Write-Output "Sysmon.exe copied to $Computer"
    Copy-Item -Path "C:\Installers\Sysmon\sysmon_config" -Destination "\\$Computer\C$\Temp" -Force -ErrorAction Stop
    Write-Output "Sysmon config copied to $Computer"

    #execute the installer on the remote computer
    Invoke-Command -ComputerName $Computer -ScriptBlock {
        Start-Process -Wait C:\Temp\Sysmon64.exe -ArgumentList $SysmonInstallCommand -Wait
    } -ErrorAction Stop
}

#loop over each computer and call install functions
foreach ($Computer in $Computers) {
    try {
        Write-Output "Installing Splunk Forwarder on $Computer..."
        Install-Splunk -Computer $Computer
        Write-Output "Installing Sysmon on $Computer..."
        Install-Sysmon -Computer $Computer
        Write-Output "Installation completed on $Computer."
    } catch {
        Write-Error "Failed to install Splunk Forwarder on $Computer. Error: $_"
    }
}

