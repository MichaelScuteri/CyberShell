#path to users text file
$UsersList = Get-Content "C:\path\to\ADUsers.txt"

# Read each line from the text file
foreach ($User in $UsersList){
    #split the line into first and last names
    $NameSplit = $User -split ' '
    $FirstName = $NameSplit[0]
    $LastName = $NameSplit[1]

    #generate username (e.g., m.hunt for Mike Hunt)
    $UserName = ($FirstName.Substring(0,1) + "." + $LastName).ToLower()

    #user parameters
    $UserParams = @{
        Name = "$FirstName $LastName"
        GivenName = $FirstName
        Surname = $LastName
        SamAccountName = $UserName
        DisplayName = "$FirstName $LastName"
        UserPrincipalName = "$UserName@raccoons.com" #change domain
        Path = "OU=_Users,DC=raccoons,DC=com" #change the OU and domain
        AccountPassword = (ConvertTo-SecureString "Password1" -AsPlainText -Force) #default password
        Enabled = $true
        #PasswordNeverExpires = $false
        #ChangePasswordAtLogon = $true
    }

    #create the user
    New-ADUser @UserParams
    Write-Host "Created user: $FirstName $LastName with username $UserName"
}
