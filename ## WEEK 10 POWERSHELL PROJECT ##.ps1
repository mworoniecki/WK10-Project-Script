                   ## WEEK 10 POWERSHELL PROJECT ##
                    
## Install Modules ##

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

Install-Module AzureAD

Connect-AzAccount


## Environmental Information ##

$Admin = "admin@M365x94713081.onmicrosoft.com" 
$AdminPassword = "Li%Fob775sE" 
$Directory = "M365x94713081.onmicrosoft.com" 
$NewUserPassword = "Pa55w.rd" 
$CsvFilePath = "C:\work\users.csv"


## Connection to Azure AD ##

$SecPass = ConvertTo-SecureString $AdminPassword -AsPlainText -Force 
$Cred = New-Object System.Management.Automation.PSCredential ($Admin, $SecPass) 
Connect-AzureAD -Credential $cred


## Password Profile for New Users ##

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $NewUserPassword


## CSV Import ##

$users = Import-CSV -Path $CsvFilePath


ForEach ($u in $users) {
    
        $upn = $u.First + "." + $u.Last + '@' + $Directory
            $display = $u.First + "" + $u.Last + "(" + $u.Department + ")"
            $MailNickName = $u.First + "." + $u.Last    
            New-AzureADUser -UserPrincipalName $upn -AccountEnabled $true -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -PasswordProfile $PasswordProfile
            }


## Creating a new user (SOLO) in Azure AD ##

New-AzureADUser -AccountEnabled $True -DisplayName "Nora Daniels" -PasswordProfile $PasswordProfile -MailNickName "NoraD" -UserPrincipalName "NoraD@M365x29244784.onmicrosoft.com"


## Creating new users (INCREMENTAL) IN Azure AD ##

Import-Module ActiveDirectory

$csvfilePath = "C:\work\users.csv"

if (Test-Path $csvFilePath)
{
    $newUsers = Import-Csv $csvfilePath
    $existingUsers = Get-ADGroupMember "Domain Users"
    }

    foreach ($u in $Users)
    {
     if (($existingUsers | Where-Object { $_.sAMAccountName -eq $newUser.sAMAccountName }) -eq $null)
    {
      {$upn = $u.First + "." + $u.Last + '@' + $Directory
       $display = $u.First + "" + $u.Last + "(" + $u.Department + ")"
       $MailNickName = $u.First + "." + $u.Last
       $user = New-AzureADUser -UserPrincipalName $upn -AccountEnabled $true -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -PasswordProfile $PasswordProfile
     }
      }
       }
