function GetHash {
    Param(
        [String]$Path,
        [String]$String,
        [ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")][String]$HashType = "SHA256"
    )
      
    if (!$Path -and !$String) {
        break
    }

    switch ( $HashType.ToUpper() ) {
        "MD5"       { $Hash = [System.Security.Cryptography.MD5]::Create() }
        "SHA1"      { $Hash = [System.Security.Cryptography.SHA1]::Create() }
        "SHA256"    { $Hash = [System.Security.Cryptography.SHA256]::Create() }
        "SHA384"    { $Hash = [System.Security.Cryptography.SHA384]::Create() }
        "SHA512"    { $Hash = [System.Security.Cryptography.SHA512]::Create() }
        "RIPEMD160" { $Hash = [System.Security.Cryptography.RIPEMD160]::Create() }
        default     { "Invalid hash type selected." }
    }

    if ($Path) {
        if (Test-Path $Path) {
            $FileName = Get-Item -Force $Path | Select-Object -ExpandProperty Fullname
            $FileData = [System.IO.File]::ReadAllBytes($FileName)
            $HashBytes = $Hash.ComputeHash($FileData)
            $PaddedHex = ""
    
            ForEach($Byte in $HashBytes) {
                $ByteInHex = [String]::Format("{0:X}", $Byte)
                $PaddedHex += $ByteInHex.PadLeft(2,"0")
            }
            return $PaddedHex
            
        } else {
            #$Path is invalid or locked.
            Write-Error -Message "$Path is invalid or locked." -Category InvalidArgument
        }
    }

    if ($String) {
        $utf8 = New-Object -TypeName System.Text.UTF8Encoding
        $Hash = [System.BitConverter]::ToString($Hash.ComputeHash($utf8.GetBytes($String)))
    
        return $Hash.ToUpper() -replace '-', ''
    }
}
