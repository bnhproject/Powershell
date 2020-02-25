# Brandon Hunt 00186124


try{
#Create OU named finance and import financepersonnel.csv directly into the new OU
New-ADOrganizationalUnit -Name finance -ProtectedFromAccidentalDeletion $false

$NewAD = Import-Csv $PSScriptRoot\financepersonnel.csv
$Path = "OU=finance,DC=ucertify,DC=com"

foreach ($ADUser in $NewAD)
{
$First = $ADUser.First_name
$Last = $ADUser.Last_name
$Name =  $ADUser.samAccount
$Display = $ADUser.First_Name + " " + $ADUser.Last_name
$Zip = $ADUser.PostalCode
$OfficePhone = $ADUser.OfficePhone
$MobilePhone = $ADUser.MobilePhone

New-ADUser -Name $Name -GivenName $First -Surname $Last -DisplayName $Display -PostalCode $Zip -OfficePhone $OfficePhone -MobilePhone $MobilePhone -Path $Path
}
#Create new database and table and import client data
Import-Module sqlps -DisableNameChecking -Force
$servername = ".\UCERTIFY3"
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server -ArgumentList $servername
$databasename = "ClientDB"
$db = New-Object Microsoft.SqlServer.Management.Smo.Database -ArgumentList $srv, $databasename
$db.Create()

Invoke-Sqlcmd -ServerInstance .\UCERTIFY3 -Database ClientDB -InputFile $PSScriptRoot\contacts.sql

$table = "dbo.Client_A_Contacts"
$db = "ClientDB"

Import-CSV $PSScriptRoot\NewClientData.csv | ForEach-Object {Invoke-Sqlcmd `
-Database ClientDB -ServerInstance .\UCERTIFY3 -Query "insert into $table (first_name,last_name,city,county,zip,officePhone,mobilePhone) Values`
('$($_.first_name)','$($_.last_name)','$($_.city)','$($_.county)','$($_.zip)','$($_.officePhone)','$($_.mobilePhone)')"
}
}
#Catch statement for system out of memory exception
catch [System.OutOfMemoryException] {
    WriteHost "A system out of memory exception has occured."
}

