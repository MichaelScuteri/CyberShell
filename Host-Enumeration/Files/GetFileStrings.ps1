function GetFileStrings { 

    Param(
        [String] $Path,
        [Int] $MatchLength,
        [String] $MatchString,
        [String] $Hashtype
    )

    #Check if file path is provided
    if (-not $Path){
        return "Please specify a file path."
    }

    #Read file content
    $content = Get-Content -Path $Path -Encoding ASCII

    #Filter strings based on MatchLength if provided
    if ($MatchLength -gt 0) {
        $strings = $content -split '\s+' | Where-Object { $_.Length -eq $MatchLength }
        write-host $strings.Length
    }
    #Search for MatchString if provided
    elseif ($MatchString -ne "") {
        $strings = $content | Select-String -Pattern $MatchString -AllMatches | ForEach-Object { $_.Matches.Value }
        if (-not $strings) {
            return "'$MatchString' not found in the file."
        }
    }
    #Remove non-alphanumeric characters if neither MatchLength nor MatchString is provided
    else {
        $strings = $content -split '\s+'
        $strings = $content -replace '[^\p{L}\p{N}]', ''
    }

    #Output each string as an object
    foreach ($string in $strings){
        $Output = New-Object PSObject -Property @{
            Strings = $string
        }
        Write-Output $Output
    }
}
