
##To Allow all scipts to be run##

Set-ExecutionPolicy Unrestricted

##EXAMPLE##
Get-ADUser -Filter {Name -eq 'Michael Woroniecki'} | Set-ADUser Job TimeLord

##EXAMPLE##
Get-ADGroup "Cloud" | Add-ADGroupMember -Members (Get-ADUser -Filter {Department -eq Cloud})

##EXAMPLE##
New-ADUser -Name "ChewDavid" -OtherAttributes @{'title'="director";'mail'="chewdavid@fabrikam.com"}


##Adding a new Column of data to an Existing CSV by PowerShell##
$CSVFile = import-csv 'C:\temp\SourceFile.csv'
$Counter = $CSVFile.count
foreach($Line in $CSVFile)
{
    $NewColumnValue = 'This is the new column value'
    $Line | Add-Member -NotePropertyName NewColumnName -NotePropertyValue $NewColumnValue
    $Counter = $Counter -1
    Write-Host $Counter
}
$CSVFile | Export-CSV 'c:\temp\ResultFile.csv'


##Script to update employeeID based on email address##

Import-module ActiveDirectory
Import-CSV “C:\PSS\UserList.csv” | % {
$mail = $_.mail
$ID = $_.EmployeeID
$users = Get-ADUser -Filter {mail -eq $mail}
Set-ADUser $Users.samaccountname -employeeID $ID
}


Import-Csv file.csv |  Select-Object *,@{Name='column3';Expression={'setvalue'}} |  Export-Csv file.csv -NoTypeInformation

| Export-CSV c:\newcsvfile.csv -NoTypeInformation