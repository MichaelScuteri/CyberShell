function GetDomainUsers(){

    $Users = Get-ADUser -Identity * -Property *

    foreach ($User in $Users){

        $AccountName = $User.SamAccountName
        $SID = $User.SID
        $CreatedTime = $User.whenCreated
        $ModifiedTime = $User.whenChanged
        $AccessedTime = $User.LastLogonDate
        $Enabled = $User.Enabled
        $LockedOut = $User.LockedOut
        $AdminCount = $User.AdminCount
        $TrustedForDelegation = $User.TrustedForDelegation
        $TrustedForAuthDelegation = $User.TrustedToAuthForDelegation
        $LogonCount = $User.LogonCount
        $BadLogonCount = $User.BadLogonCount
        $BadPasswordTime = $User.badPasswordTime
        $BadPasswordCount = $User.badPwdCount
        $LastBadPasswordAttempt = $User.lastBadPasswordAttempt
        $PasswordExpired = $User.PasswordExpired
        $PasswordLastSet = $User.PasswordLastSet
        $PasswordNeverExpires = $User.PasswordNeverExpires 
        $PasswordNotRequired = $User.PasswordNotRequired 
        $CannotChangePassword = $User.CannotChangePassword
        $PrimaryGroup = $User.PrimaryGroup 
        $MemberOf = $User.MemberOf 
        $Certificates = $User.Certificates 

        $Output = New-Object PSObject -Property @{

           AccountName = $AccountName
           SID = $SID
           CreatedTime = $CreatedTime
           ModifiedTime = $ModifiedTime
           AccessedTime = $AccessedTime
           Enabled = $Enabled
           Locked = $LockedOut
           AdminCount = $AdminCount
           TrustedForDelegation = $TrustedForDelegation
           TrustedForAuthDelegation = $TrustedForAuthDelegation
           LogonCount = $LogonCount
           BadLogonCount = $BadLogonCount
           BadPasswordTime = $BadPasswordTime
           BadPasswordCount = $BadPasswordCount
           LastBadPasswordAttempt = $LastBadPasswordAttempt
           PasswordExpired = $PasswordExpired
           PasswordLastSet = $PasswordLastSet
           PasswordNeverExpires = $PasswordNeverExpires
           PasswordNotRequired = $PasswordNotRequired
           CannotChangePassword = $CannotChangePassword
           PrimaryGroup = $PrimaryGroup
           MemberOf = $MemberOf
           Certificates = $Certificates

        }
        Write-Output $Output
    }

}