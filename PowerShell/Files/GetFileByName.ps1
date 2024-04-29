function FileByName {
	Param (
		[String] $Path,
		[String] $NameFilter,
		[String] $HashType,
		[String] $Recurse
	)

	if ($Recurse -eq "True") {
		$Files = Get-ChildItem -Force -Path "$($Path)" -Filter "$($NameFilter)" -Recurse
	} else {
		$Files = Get-ChildItem -Force -Path "$($Path)" -Filter "$($NameFilter)"
	}

	if (!$Files) {
		Write-Host "No Files Matched"
	}

	$FileArray = @()

	if ($HashType) {
		foreach ($CurrentFile in $Files) {
			$File = GetFile -Path $CurrentFile.FullName -HashType $HashType 
			$FileArray += $File
		}
	} else {
		foreach ($CurrentFile in $Files) {
			$File = GetFile -Path $CurrentFile.FullName
			$FileArray += $File
		}
	}

	Write-Output $FileArray
}