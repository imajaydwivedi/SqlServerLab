# Input Variables
$SetupISOImagePath = 'G:\MICROSOFT_SQL_SERVER_2014_ENTERPRISE_EDITION_X64-DVTiSO[rarbg]\d-351mse.iso';
$SqlEdition = 'Enterprise';
$pInstanceName = 'SQL2014';
$pSqlDatabaseEngineAgentServiceAccount = 'Contso\SQLServices'
$pSqlDatabaseEngineAgentServiceAccountPassword = 'Pa$$w0rd'
$SqlSysAdminAccounts = @('Contso\SQLDBA', 'Contso\SQLServices')
$FeatureParameters = @('SQLEngine', 'Replication', 'FullText', 'BC', 'Conn', 'SSMS', 'ADV_SSMS', 'SNAC_SDK', 'SDK')
$InstanceRootDirectory = 'E:\SysDbs'
$SqlDataDirectory = "E:\Data\$pInstanceName"
$SqlLogDirectory = "E:\Log\$pInstanceName"
$SqlBackupDirectory = "E:\Backup\$pInstanceName"
$SqlTempDbDirectory = "E:\TempDb\$pInstanceName"
$pSqlSAPassword = 'Pa$$w0rd'

$pSqlSysAdminAccounts = '';
$SqlSysAdminAccounts | foreach {$pSqlSysAdminAccounts += '"' + $_ + '" '}
$pFeatureParameters = '';
$FeatureParameters | foreach {$pFeatureParameters += '"' + $_ + '" '}
$pInstanceRootDirectory = '"' + $InstanceRootDirectory + '"';
$pSqlDataDirectory = '"' + $SqlDataDirectory + '"';
$pSqlBackupDirectory = '"' + $SqlBackupDirectory + '"';
$pSqlTempDbDirectory = '"' + $SqlTempDbDirectory + '"';
$pSqlLogDirectory = '"' + $SqlLogDirectory + '"';
if ($SqlEdition -eq 'Standard') {
  $productKey = 'P7FRV-Y6X6Y-Y8C6Q-TB4QR-DMTTK';
}
elseif ($SqlEdition -eq 'Developer') {
  $productKey = '82YJF-9RP6B-YQV9M-VXQFR-YJBGX';
}
elseif ($SqlEdition -eq 'Enterprise') {
  $productKey = '27HMJ-GH7P9-X2TTB-WPHQC-RG79R';
}


$mountResult = Mount-DiskImage $SetupISOImagePath -PassThru;
$setupDriveLetter = ($mountResult | Get-Volume).DriveLetter + ':\';

Set-Location $setupDriveLetter;

Setup.exe /Q /ACTION=Install /QS /IACCEPTSQLSERVERLICENSETERMS /FEATURES=$pFeatureParameters /INSTANCENAME=$pInstanceName /SQLSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /SQLSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /AGTSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCSTARTUPTYPE=Automatic /SQLSYSADMINACCOUNTS=$pSqlSysAdminAccounts /PID=27HMJ-GH7P9-X2TTB-WPHQC-RG79R /INSTALLSQLDATADIR=$pInstanceRootDirectory /SQLUSERDBDIR=$pSqlDataDirectory /SQLUSERDBLOGDIR=$pSqlLogDirectory /SQLTEMPDBDIR=$pSqlTempDbDirectory /SQLTEMPDBLOGDIR
=$pSqlTempDbDirectory /SQLBACKUPDIR=$pSqlBackupDirectory /BROWSERSVCSTARTUPTYPE=Automatic /SECURITYMODE=SQL /SAPWD=$pSqlSAPassword /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /ADDCURRENTUSERASSQLADMIN /TCPENABLED=1
/INDICATEPROGRESS /HIDECONSOLE


