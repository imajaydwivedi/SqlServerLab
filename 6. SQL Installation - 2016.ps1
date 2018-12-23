# ***************************************************************************************
# Unattended Installation of SQL Server 2016
# History:- Developer = OK
#           Enterprise = Not Tested
#           Standard = Not Tested
# ***************************************************************************************

# Input Variables
$SqlSetupInventoryPath = '\\DC\SQL_Server_Setups';
$pSqlVersion = '2016'
$SqlEdition = 'Developer';
# Load Product Keys Array from File, or Manually provide Serial Key
 & '.\6. SQL Installation - Product Keys.ps1'
$productKey = ($pKeyServerEdition | Where-Object {$_.Edition -eq $SqlEdition -and $_.Version -eq $pSqlVersion}).pKey;
$pInstanceName = 'MSSQLSERVER';
$pSqlDatabaseEngineAgentServiceAccount = 'Contso\SQLServices'
$pSqlDatabaseEngineAgentServiceAccountPassword = 'Pa$$w0rd'
$SqlSysAdminAccounts = @('Contso\SQLDBA', 'Contso\SQLServices')
$FeatureParameters = @('SQLEngine', 'Replication', 'FullText', 'BC', 'Conn', 'SNAC_SDK', 'SDK')
$InstanceRootDirectory = 'E:\SysDbs'
$SqlDataDirectory = "E:\Data\$pInstanceName"
$SqlLogDirectory = "E:\Log\$pInstanceName"
$SqlBackupDirectory = "E:\Backup\$pInstanceName"
$SqlTempDbDirectory = "E:\TempDb\$pInstanceName"
$pSqlSAPassword = 'Pa$$w0rd'


# Derived Variables
$SetupISOImagePath = "$SqlSetupInventoryPath\2016\$SqlEdition\SqlServer_2016_$SqlEdition.ISO";
$pSqlSysAdminAccounts = '';
$SqlSysAdminAccounts | foreach {$pSqlSysAdminAccounts += '"' + $_ + '" '}
$pFeatureParameters = '';
$FeatureParameters | foreach {$pFeatureParameters += '"' + $_ + '" '}
$pInstanceRootDirectory = '"' + $InstanceRootDirectory + '"';
$pSqlDataDirectory = '"' + $SqlDataDirectory + '"';
$pSqlBackupDirectory = '"' + $SqlBackupDirectory + '"';
$pSqlTempDbDirectory = '"' + $SqlTempDbDirectory + '"';
$pSqlLogDirectory = '"' + $SqlLogDirectory + '"';

$mountResult = Mount-DiskImage $SetupISOImagePath -PassThru;
$setupDriveLetter = ($mountResult | Get-Volume).DriveLetter + ':\';

$sqlSetupPath
Set-Location $setupDriveLetter;

$OutputVariable = cmd.exe /c "Setup.exe /QS /ACTION=Install /ENU /IACCEPTSQLSERVERLICENSETERMS /UpdateEnabled=0 /FEATURES=$pFeatureParameters /INSTANCENAME=$pInstanceName /SQLSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /SQLSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /AGTSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCSTARTUPTYPE=Automatic /SQLSYSADMINACCOUNTS=$pSqlSysAdminAccounts /PID=$productKey /INSTALLSQLDATADIR=$pInstanceRootDirectory /SQLUSERDBDIR=$pSqlDataDirectory /SQLUSERDBLOGDIR=$pSqlLogDirectory /SQLTEMPDBDIR=$pSqlTempDbDirectory /SQLTEMPDBLOGDIR=$pSqlTempDbDirectory /SQLBACKUPDIR=$pSqlBackupDirectory /SQLSVCINSTANTFILEINIT=1 /BROWSERSVCSTARTUPTYPE=Automatic /SECURITYMODE=SQL /SAPWD=$pSqlSAPassword /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /TCPENABLED=1 /HIDECONSOLE" | Out-String;

Write-Host $OutputVariable -ForegroundColor DarkRed;
<# # Message in case of Failure

SQL Server 2016 transmits information about your installation experience, as well as other usage and performance data, to Microsoft to help improve the product. To learn more about SQL Server 2016 data processing and privacy controls, please see the Privacy 
Statement.
The following error occurred:
The setting 'IACCEPTPYTHONLICENSETERMS' specified is not recognized.

Error result: -2068578301
Result facility code: 1204
Result error code: 3

Please review the summary.txt log for further details
Microsoft (R) SQL Server 2016 13.00.5026.00

Copyright (c) 2016 Microsoft.  All rights reserved.

#>

<# # Message in case of Success
Microsoft (R) SQL Server 2014 12.00.2000.08

Copyright (c) Microsoft Corporation.  All rights reserved.

#>

# Eject/Unmount ISO Image
Dismount-DiskImage -ImagePath $SetupISOImagePath;