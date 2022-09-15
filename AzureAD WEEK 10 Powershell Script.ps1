Install-Module AzureAD

Connect-AzAccount

$Admin = "admin@M365x29244784.onmicrosoft.com" 
$AdminPassword = "DR7Y\lo$*F4" 
$Directory = "M365x29244784.onmicrosoft.com" 
$NewUserPassword = "Pa55w.rd" 
$CsvFilePath = "C:\Work\users.csv"



Function Import-Users 


##Password Profile for New Users##

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $NewUserPassword

# Edit this line to match the filepath of your CSV
   $ADUsers = Import-CSV C:\work\users.csv

       Foreach ($user in $ADUsers) {
       
       # Edit to match the criteria used in your CSV
       $upn = $u.First + "." + $u.Last + '@' + $Directory
       $display = $u.First + "" + $u.Last + "(" + $u.Department + ")"
       $MailNickName = $u.First + "." + $u.Last
       New-AzureADUser -UserPrincipalName $upn -AccountEnabled $true -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -PasswordProfile $PasswordProfile    
       }                                                
             
                                                                                    
        # Assumes an already established naming convention for SamAccountName, edit to match your naming convention
        If (Get-AzureADUser -Filter {display -eq $display}) 
       {
        Write-Warning "User account for $display already exists in Azure Active Directory."
       }

        Else
        {
        # This assumes that the user's department, OU, and security group all use the same name
        New-AzureADUser `
        -UserPrincipalName "$upn" `
        -AccountEnabled "$true" `
        -DisplayName "$display" `
        -GivenName "$u.First" `
        -MailNickName "$Mailnickname" `
        -Surname "$u.last" `
        -Department "$u.Department" `
        -PasswordProfile "$PasswordProfile" 

        New-AzureADUser -UserPrincipalName $upn -AccountEnabled $true -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department 
                
        }
                                                                                                                                     


Write-Host "The user $display has been created."                                                                                                                                                                                                                                                                                                                                                                                                                                          