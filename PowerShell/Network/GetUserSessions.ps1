function GetUserSessions{

    $computer = $env:COMPUTERNAME
    $users = query user /server:$Computer

    $users = $users | ForEach-Object {
        (($_.trim() -replace ">" -replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", '$1  none  $2' -replace "\s{2,}", "," -replace "none", $null))
    } | ConvertFrom-Csv
    
    foreach ($user in $users)
    {
        $iduser = New-Object System.Security.Principal.NTAccount($user.USERNAME)
        $sid = $iduser.Translate([System.Security.Principal.SecurityIdentifier])

        $Output = New-Object PSObject -Property @{
            Username = $user.USERNAME
            State = $user.STATE
            SessionName = $user.SESSIONNAME
            SID = $sid
            IdleTime = $user."IDLE TIME"
            LogonTime = $user."LOGON TIME"
        }
        Write-Output $Output
    }
}