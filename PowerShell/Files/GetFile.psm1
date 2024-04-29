#Require -Version 5.0
using module C:\HostFramework\Console\Objects\baseModule.psm1

class GetFile : BaseModule {
    $Name = "GetFile"
    $BasePath = "Files"
    $Payload = "GetFile.ps1"
    $HelperDependencies = @("GetHash")
    $ModuleDependencies = $null
    $ReflectiveDLLSDependencies = $null
    $Version = "1"
}
# Add Module
$Global:Console.Modules.Add([GetFile]::new())

# Function Prototype
function Get-File {
     <#
	.SYNOPSIS
		Get information on a single file.
	.DESCRIPTION
        Get information on a single file. Also returns useful information on a file including timestamps, file hash, permissions, owner
        and version information.
	.EXAMPLE
		Get-File -Path C:\Temp -NameFilter *.ini
		
		Return an array of custom objects that each represent a file in the C:\Temp directory that match the string pattern '.ini'.
	.EXAMPLE
        Get-File -Path C:\Temp\beacon.exe

        Return a custom psobject that contains information on the file at path C:\Temp\beacon.exe. HAsh is calculated as the default SHA256.
    .EXAMPLE
        Get-File -Path C:\Temp\beacon.exe -HashType MD5

        Return a custom psobject that contains information on the file at path C:\Temp\beacon.exe. Hash is calculated as an MD5.
	.PARAMETER -Path [String]
		Define path to start file search from. Full path name required.
	.PARAMETER -HashType [String]
        Define what hashtyp to calculate for each file. Options are: "MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160".
        If no hashtype is defined the file will not be hashed.
    .PARAMETER -Display ValidateSet([String])
        Select what method to display output. Options are: "Gridview", "List", "Table", "Count", "Raw". Count is default.
	.NOTES
    #>   
    
    [CmdletBinding()]
    Param (
        [System.String] $RunOnGroup = $null,
        [Switch] $SerialConnections = $false,        
        [ValidateSet("Gridview", "List", "Table", "Count", "Raw")] $Display = "Count",
        [Parameter(Mandatory=$False,Position=0)][System.String]$Path,
        [Parameter(Mandatory=$False,Position=1)][ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")][String]$HashType
    )

    # Name of module to Run (MUST be the same as the 'Name' property in the class)
    $Name = "GetFile"
    if ($HashType) {
        $Call = "GetFile -Path '$($Path)' -HashType '$($HashType)'"
    } else {
        $Call = "GetFile -Path '$($Path)'"
    }
    

    # Find this.module in the list of loaded modules
    $Module = $Global:Console.Modules | Where-Object -Property "Name" -eq $Name

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
