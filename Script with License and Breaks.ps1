
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

Install-Module AzureAD

Connect-AzAccount


##Environmental Information##

$Admin = "admin@M365x29244784.onmicrosoft.com" 
$AdminPassword = "DR7Y\lo$*F4" 
$Directory = "M365x29244784.onmicrosoft.com" 
$NewUserPassword = "Pa55w.rd" 
$CsvFilePath = "C:\Work\users.csv"


##Connection to Azure AD##

$SecPass = ConvertTo-SecureString $AdminPassword -AsPlainText -Force 
$Cred = New-Object System.Management.Automation.PSCredential ($Admin, $SecPass) 
Connect-AzureAD -Credential $cred


##Password Profile for New Users##

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $NewUserPassword




##CSV Import#

$users = Import-CSV -Path $CsvFilePath


ForEach ($u in $users) {
    
    $upn = $u.First + "." + $u.Last + '@' + $Directory
    $display = $u.First + "" + $u.Last + "(" + $u.Department + ")"
    $MailNickName = $u.First + "." + $u.Last  
    New-AzureADUser -UserPrincipalName $upn -AccountEnabled $true -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -PasswordProfile $PasswordProfile
        }

pause


##License Assignment##

$SkuId = (Get-AzureADSubscribedSku | Where SkuPartNumber -eq "ENTERPRISEPREMIUM").SkuID
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = $SkuId
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License

$members = Get-AzureADUser -Filter "Department eq 'Cloud'"
foreach ($m in $members) {
    Set-AzureADUser -ObjectId $m.ObjectId -UsageLocation US
    Set-AzureADUserLicense -ObjectId $m.ObjectId -AssignedLicenses $LicensesToAssign                                                                                    
}


pause

## Creating a new user in Azure AD ##

##Password Profile for New Users##

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $NewUserPassword

New-AzureADUser -AccountEnabled $True -DisplayName "Nora Daniels(MSSA)" -PasswordProfile $PasswordProfile -MailNickName "NoraD" -UserPrincipalName "NoraD@M365x29244784.onmicrosoft.com"


pause

