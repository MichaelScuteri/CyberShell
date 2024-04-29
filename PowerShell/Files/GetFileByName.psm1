#Require -Version 5.0
using module C:\HostFramework\Console\Objects\baseModule.psm1

# Windows Object
class FileByName : BaseModule {
    $Name = "FileByName"
    $BasePath = "Files"
    $Payload = "GetFileByName.ps1"
    $HelperDependencies = $null
    $ModuleDependencies = @("GetFile")
    $ReflectiveDLLSDependencies = $null
    $Version = "1"
}
# Add Module
$Global:console.Modules.add([FileByName]::new())

# Function Prototype
function Get-FileByName {
    <#
	.SYNOPSIS
		Lists all files in a provided path whose name matches a set pattern.
	.DESCRIPTION
		Lists all files in a provided path whose name matches a set pattern. Can be used to recursively search a directory.
		Also returns useful information on a file including timestamps, file hash (optional), permissions, owner and version information.
	.EXAMPLE
		Get-FileByName -Path C:\Temp -NameFilter *.ini
		
		Return an array of custom objects that each represent a file in the C:\Temp directory that match the string pattern '.ini'.
	.EXAMPLE
		Get-FileByName -Path C:\Temp -NameFilter *.ini -Recurse
		
		Return an array of custom objects that each represent a file in the C:\Temp directory that match the string pattern '.ini'.
        Search recursively from the C:\Temp path.
    .EXAMPLE
        Get-FileByName -Path C:\Temp

        Return an array of custom objects that each represent a file in the C:\Temp directory.
	.PARAMETER -Path [String]
		Define path to start file search from. Full path name required.
	.PARAMETER -NameFilter [String]
		Define string pattern to search for. Wildcards accepted.
	.PARAMETER -HashType [String]
        Define what hashtyp to calculate for each file. Options are: "MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160". SHA256 is default.
    .PARAMETER -Recurse [Switch]
        Search recursively.
    .PARAMETER -Hash [Switch]
        Select whether to hash files
    .PARAMETER -Display ValidateSet([String])
        Select what method to display output. Options are: "Gridview", "List", "Table", "Count", "Raw". Count is default.
	.NOTES
    #>
    
    [CmdletBinding()]
    Param(
        [System.String] $RunOnGroup = $null,
        [switch] $SerialConnections = $false,        
        [ValidateSet("Gridview", "List", "Table", "Count", "Raw")] $Display = "Count",
        [Parameter(Mandatory=$False,Position=0)][String]$Path,
        [Parameter(Mandatory=$False,Position=2)][String]$NameFilter = "*",
        [Switch] $Hash,
		[Parameter(Mandatory=$False,Position=3)][ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")][String]$HashType = "SHA256",
        [Parameter(Mandatory=$False,Position=4)][switch]$Recurse
    )

    # Name of module to Run
    $Name = "FileByName"
    if ($Hash) {
        $Call = "FileByName -Path '$($Path)' -NameFilter '$($NameFilter)' -Hash -HashType '$($HashType)' -Recurse $($Recurse)"
    } else {
        $Call = "FileByName -Path '$($Path)' -NameFilter '$($NameFilter)' -Recurse $($Recurse)"
    }
    

    # Get the first module for the currently Selected Target (If we are running on a group then this will change from target to target)
    $Module = $Global:console.Modules | Where-Object -Property "Name" -eq $Name

    # Run the module
    try {
        if ($Module) {
            if ($RunOnGroup) {
                $Module.RunOnGroup($Call, $RunOnGroup, $SerialConnections)
                show-results -Display $Display -Module $Name -Group $RunOnGroup
            } else {
                $Module.RunOnTarget($Call)
                show-results -Display $Display -Module $Name
            }
        } else {
            Write-Message -Message "Error there is no loaded module for $($Name)" -level 0
        }
    } catch {
        Write-Message -Message $_.Exception -level 0
    }
}
