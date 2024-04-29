#Require -Version 5.0
using module C:\HostFramework\Console\Objects\baseModule.psm1

# Windows Object
class GetDNSCache : baseModule {
    $Name = "GetDNSCache"
    $BasePath = "Network"
    $Payload = "GetDNSCache.ps1"
    $ModuleDependencies = $null
    $HandlerDependencies = $null
    $ReflectiveDLLSDependencies = $null
    $Version = "1"
}
# Add Module
$Global:Console.Modules.Add([GetDNSCache]::new())

# Function Prototype
function GetDNSCache {
    <#
    .SYNOPSIS
        Collect basic operating system information on the current host.
    .DESCRIPTION
        Collect basic operating system information on the current host including; OS Version, OS Architecture, OS Service Pack,
        PowerShell Version (Major), Timezone and applied Windows Patches.
    .EXAMPLE
        GetDNSCache
        
        Get processes information
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
    $Name = "GetDNSCache"

    # Call of the modules, this will include params.
    # E.G.  "GetDNSCache -ProcessID '$($ProcessID)'"
    # This will pass the named argument 'ProcessID' to the payload script
    $Call = "GetDNSCache" 

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
