function GetUserSessions{

    $Computer = $env:COMPUTERNAME
    $Users = query User /server:$Computer

    $Users = $Users | ForEach-Object {
        (($_.trim() -Replace ">" -Replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", 
        '$1  none  $2' -Replace "\s{2,}", "," -Replace "none", $null))
    } | ConvertFrom-Csv
    
    foreach ($User in $Users)
    {
        $IdUser = New-Object System.Security.Principal.NTAccount($User.UserNAME)
        $SID = $IdUser.Translate([System.Security.Principal.SecurityIdentifier])

        $Output = New-Object PSObject -Property @{
            Username = $User.UserNAME
            State = $User.STATE
            SessionName = $User.SESSIONNAME
            SID = $SID
            IdleTime = $User."IDLE TIME"
            LogonTime = $User."LOGON TIME"
        }
        
        Write-Output $Output
    }
}