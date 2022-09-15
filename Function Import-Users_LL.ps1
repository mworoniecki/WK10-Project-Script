Function Import-Users 
{
    # Edit this line to match the filepath of your CSV
    $ADUsers = Import-CSV C:\Banshees.csv

    Foreach ($user in $ADUsers)
    {
        # Edit to match the criteria used in your CSV
        $FirstName = $User.First
        $LastName = $User.Last
        $Department = $User.Department
        $Job = $User.Job
        $Company = $User.Company
        $State = $User.State
        $Phone = $User.Phone
        $SamAccountName = ($User.First)+($User.Last)
    
    
        # Assumes an already established naming convention for SamAccountName, edit to match your naming convention
        If (Get-ADUser -Filter {SamAccountName -eq $SamAccountName}) 
        {
        Write-Warning "User account for $FirstName $LastName already exists in ACtive Directory."
        }

        Else
        {
        # This assumes that the user's department, OU, and security group all use the same name
        New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName "$FirstName$LastName" `
        -UserPrincipalName "$FirstName$LastName@$Company.com" `
        -DisplayName "$FirstName $LastName" `
        -Title $Job `
        -State $State `
        -Company $Company `
        -OfficePhone $Phone `
        -EmailAddress "$FirstName.$LastName@$Company.com" `
        -AccountPassword (ConvertTo-SecureString "Pa55w.rd" -AsPlainText -Force) `
        -ChangePasswordAtLogon $True `
        -Enabled $True `
        -Path "OU=$Department,DC=$Company,DC=Com"

        Add-ADGroupMember -Members "$FirstName$LastName" -Identity $Department


        Write-Host "The user $FirstName $LastName has been created."
        }   
    }
}