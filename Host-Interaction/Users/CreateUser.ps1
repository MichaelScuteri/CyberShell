function CreateUser {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Username,
        [String]$Domain = "raccoons",
        [String]$Group = "_Users",
        [Switch]$LocalAccount
    )

    if ($LocalAccount.IsPresent) {
        LocalAccount @args
    }
    else {
        DomainUser @args
    }

}

function DomainUser {
    $UserParams = @{
        SamAccountName = $Username
        UserPrincipalName = "$Username@$Domain.com" #change domain
        Path = "OU=$Group,DC=$Domain,DC=com" #change the OU and domain
        AccountPassword = (ConvertTo-SecureString "Password1" -AsPlainText -Force) #default password
        Enabled = $true
        #PasswordNeverExpires = $false
        #ChangePasswordAtLogon = $true
    }

    New-ADUser @UserParams
}

function LocalAccount {
    $UserParams = @{
        Name = $Username
    }

    New-LocalUser @UserParams
}

CreateUser @args