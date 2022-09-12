ROUND 2

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

Connect-AzAccount


                ##Install Modules##
Install-Module -Name AZ -Scope CurrentUser -Repository psgallery -force




Install-Module AzureAD

##Environmental Information##

$Admin = "admin@M365x94713081.onmicrosoft.com" 
$AdminPassword = "Li%Fob775sE" 
$Directory = "M365x94713081.onmicrosoft.com" 
$NewUserPassword = "Pa55w.rd" 
$CsvFilePath = "C:\work\users.csv"


##Connection to Azure AD##

$SecPass = ConvertTo-SecureString $AdminPassword -AsPlainText -Force 
$Cred = New-Object System.Management.Automation.PSCredential ($Admin, $SecPass) 
Connect-AzureAD -Credential $cred


##Password Profile for New Users##

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $NewUsePassword


##CSV Import#

$users = Import-CSV -Path $CsvFilePath


ForEach ($u in $users) {
    
        $upn = $u.First + "." + $u.Last + '@' + $Directory
            $display = $u.First + "" + $u.Last + "(" + $u.Department + ")"
            $MailNickName = $u.First + "." + $u.Last    
            New-AzureADUser -UserPrincipalName $upn -AccountEnabled $true -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -PasswordProfile $Password
            }