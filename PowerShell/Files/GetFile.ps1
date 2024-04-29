function GetFile () {
    Param(
        [String] $Path,
        [String] $HashType
    )

    if (Test-Path($Path)) {
        $File = Get-Item -Force -Path $Path
        $ACL = Get-Acl -Path $Path
    } else {
        return (New-Object PSObject -Property @{Result = "Can't Find File: $($Path)"})
    }

    if ($File.GetType().Name -ne "DirectoryInfo") {
        if ($HashType) {
            try {
                $HashValue = GetHash -Path $Path -HashType $HashType
            } catch {
                $HashValue = "Failed to hash file"
            }
        } else {
            $HashValue = "-"
            $HashType = "-"
        }

    } else {
        $HashValue = "Target is a directory. Not hashing."
        $HashType = "-"
    }
    
    $Hash = New-Object PSObject -Property @{
        Type = $HashType
        Value = $HashValue
    }

    $VersionInfo = New-Object PSObject -Property @{
        Comments = $File.VersionInfo.Comments
        CompanyName = $File.VersionInfo.CompanyName
        FileBuildPart = $File.VersionInfo.FileBuildPart
        FileDescription = $File.VersionInfo.FileDescription
        FileMajorPart = $File.VersionInfo.FileMajorPart
        FileMinorPart = $File.VersionInfo.FileMinorPart
        FileName = $File.VersionInfo.FileName
        FilePrivatePart = $File.VersionInfo.FilePrivatePart
        FileVersion = $File.VersionInfo.FileVersion
        InternalName = $File.VersionInfo.InternalName
        IsDebug = $File.VersionInfo.IsDebug
        IsPatched = $File.VersionInfo.IsPatched
        IsPreRelease = $File.VersionInfo.IsPreRelease
        IsPrivateBuild = $File.VersionInfo.IsPrivateBuild
        IsSpecialBuild = $File.VersionInfo.IsSpecialBuild
        Language = $File.VersionInfo.Language
        LegalCopyright = $File.VersionInfo.LegalCopyright
        LegalTrademarks = $File.VersionInfo.LegalTrademarks
        OriginalFilename = $File.VersionInfo.OriginalFilename
        PrivateBuild = $File.VersionInfo.PrivateBuild
        ProductBuildPart = $File.VersionInfo.ProductBuildPart
        ProductMajorPart = $File.VersionInfo.ProductMajorPart
        ProductMinorPart = $File.VersionInfo.ProductMinorPart
        ProductName = $File.VersionInfo.ProductName
        ProductPrivatePart = $File.VersionInfo.ProductPrivatePart
        ProductVersion = $File.VersionInfo.ProductVersion
        SpecialBuild = $File.VersionInfo.SpecialBuild
    }

    $o = New-Object PSObject -Property @{
        Name = $File.BaseName
        Path = $File.FullName
        Hash = $Hash
        Permissions = $File.Mode
        Owner = $ACL.Owner
        Size = $File.Length
        CreatedTime = $File.CreationTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
        AccessedTime = $File.LastAccessTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
        ModifiedTime = $File.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
        VersionInfo = $VersionInfo
    }

    if (!$o) {
        $o = New-Object PSObject -Property @{
            Name = "Failed to open file"
            Path = $Path
            Hash = "-"
            Permissions = "-"
            Owner = "-"
            Size = "-"
            CreatedTime = "-"
            AccessedTime = "-"
            ModifiedTime = "-"
            VersionInfo = "-"
        }
    }

    return $o
}  
