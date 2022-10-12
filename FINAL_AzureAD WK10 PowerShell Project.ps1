Install-Module AzureAD

Connect-AzAccount

##Environmental Information##


$Admin = "admin@M365x70272383.onmicrosoft.com" 
$AdminPassword = "7#3aNqQmRw&" 
$Directory = "M365x70272383.onmicrosoft.com" 
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
        New-AzureADUser -UserPrincipalName $upn -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -JobTitle $u.Job -PasswordProfile $PasswordProfile -AccountEnabled $true
        }
        
        

pause

##Group Assignment##

New-AzureADGroup -DisplayName "Crazy Town" -SecurityEnabled $true -MailEnabled $false -MailNickName "CrazyTownSecurityGroup"

$members = Get-AzureADUser -Filter "Department eq 'Banshees'"
$Group = Get-AzureAdGroup -SearchString "Crazy Town"


    foreach ($m in $members) {

     Add-AzureADGroupMember -ObjectId $Group.ObjectId -RefObjectId $m.ObjectId
     Get-AzureADGroupMember -ObjectId $Group.ObjectId
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

##Adding Newer Users##

$users = Import-CSV -Path $CsvFilePath


ForEach ($u in $users) {
    
            $upn = $u.First + "." + $u.Last + '@' + $Directory
            $display = $u.First + "" + $u.Last + "(" + $u.Department + ")"
            $MailNickName = $u.First + "." + $u.Last  
            New-AzureADUser -UserPrincipalName $upn -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -JobTitle $u.Job -PasswordProfile $PasswordProfile -AccountEnabled $true
                                            }
                                                                                              

# Assumes an already established naming convention for SamAccountName, edit to match your naming convention
  
  If (Get-AzureADUser -Filter "'display' eq '$display'")
   
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
     
     New-AzureADUser -UserPrincipalName $upn -DisplayName $display -GivenName $u.First -MailNickName $MailNickName -Surname $u.Last -Department $u.Department -JobTitle $u.Job -PasswordProfile $PasswordProfile -AccountEnabled $true
          }