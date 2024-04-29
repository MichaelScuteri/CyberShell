#Require -Version 5.0
using module C:\HostFramework\Console\Objects\baseModule.psm1

# Windows Object
class GetNetStat : baseModule {
    $Name = "GetNetStat"
    $BasePath = "Network"
    $Payload = "GetNetStat.ps1"
    $ModuleDependencies = @("GetProcesses")
    $HandlerDependencies = $null
    $ReflectiveDLLSDependencies = $null
    $Version = "1"
}
# Add Module
$Global:Console.Modules.Add([GetNetStat]::new())

# Function Prototype
function GetNetStat {
    <#
    .SYNOPSIS
        Collect basic networking information on the current host.
    .DESCRIPTION
        Collect basic network information on the current host including; Foreign/Local Address, Remote/Local Port,
        Process ID, Protocol and State.
    .EXAMPLE
        GetNetStat
    
    .PARAMETER -Display ValidateSet([String])
        Select what method to display output. Options are: "Gridview", "List", "Table", "Count", "Raw". Count is default.
    .NOTES
    #>
    [CmdletBinding()]
    Param(
        [System.String] $RunOnGroup = $null,
        [Switch] $SerialConnections = $false,        
        [ValidateSet("Gridview", "List", "Table", "Count", "Raw")] $Display = "Count"
        # inputs go here
    )

    # Name of module to Run (MUST be the same as the 'Name' property in the class)
    $Name = "GetNetStat"

    # Call of the modules, this will include params.
    # E.G.  "GetNetStat -ProcessID '$($ProcessID)'"
    # This will pass the named argument 'ProcessID' to the payload script
    $Call = "GetNetStat" 

    # Get the first module for the currently Selected Target (If we are running on a group then this will change from target to target)
    $Module = $Global:console.Modules | Where-Object -Property "Name" -eq $Name

    # Run the module
    try {
        if ($Module) {
            if ($RunOnGroup) {
                $Module.RunOnGroup($Call, $RunOnGroup, $SerialConnections)
                Show-Results -Display $Display -Module $Name -Group $RunOnGroup
            } else {
                $Module.RunOnTarget($Call)
                Show-Results -Display $Display -Module $Name
            }
        } else {
            Write-Message -Message "Error there is no loaded module for $($Name)" -level 0
        }
    } catch {
        Write-Message -Message $_.Exception -level 0
    }
}
