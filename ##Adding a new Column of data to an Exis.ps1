##Adding a new Column of data to an Existing CSV by PowerShell##


$CSVFile = import-csv 'C:\work\users.csv'

$Counter = $CSVFile.count
foreach($Line in $CSVFile)
    {
    $NewColumnValue = 'US'
    $Line | Add-Member -NotePropertyName country -NotePropertyValue $NewColumnValue
    $Counter = $Counter -6
    Write-Host $Counter
    }
    
 $CSVFile | Export-CSV 'c:\work\users.csv' -NoTypeInformation