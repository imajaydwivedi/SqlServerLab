# ***************************************************************************************
# Unattended Installation of SQL Server 2012
# History:- Developer = Not Tested
#           Enterprise = OK
#           Standard = OK
# ***************************************************************************************
if( (Get-ExecutionPolicy) -ne 'ByPass') {
    Write-Host "Execution Policy has been set to 'ByPass' for this Session. Kindly re-run this script." -ForegroundColor Yellow;
    exit
}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force;

# Input Variables
$SqlSetupInventoryPath = '\\DC\SQL_Server_Setups';
$pSqlVersion = '2012'
$SqlEdition = 'Standard';
$pInstanceName = 'MSSQLSERVER';
$pSqlDatabaseEngineAgentServiceAccount = 'Contso\SQLServices'
$pSqlDatabaseEngineAgentServiceAccountPassword = 'Pa$$w0rd'
$SqlSysAdminAccounts = @('Contso\SQLDBA', 'Contso\SQLServices')
$FeatureParameters = @('SQLEngine', 'Replication', 'FullText', 'BC', 'Conn', 'SSMS', 'ADV_SSMS', 'SNAC_SDK', 'SDK')
$InstanceRootDirectory = 'E:\SysDbs'
$SqlDataDirectory = "E:\Data\$pInstanceName"
$SqlLogDirectory = "E:\Log\$pInstanceName"
$SqlBackupDirectory = "E:\Backup\$pInstanceName"
$SqlTempDbDirectory = "E:\TempDb\$pInstanceName"
$pSqlSAPassword = 'Pa$$w0rd';
# Load Product Keys Array from File, or Manually provide Serial Key
try { Invoke-Expression -Command "$SqlSetupInventoryPath\SQL_Lab\6. SQL Installation - Product Keys.ps1"; } 
catch { 
    try { & '.\6. SQL Installation - Product Keys.ps1' }
    catch {
        try {. "$PSScriptRoot\6. SQL Installation - Product Keys.ps1"}
        catch { Write-Host "Could not fetch Product Key from '6. SQL Installation - Product Keys.ps1' script file." -ForegroundColor Red;
                Write-Host 'Kindly set "$productKey" = ($pKeyServerEdition variable manually' -ForegroundColor Red;
        }
        finally {
            $productKey = ($pKeyServerEdition | Where-Object {$_.Edition -eq $SqlEdition -and $_.Version -eq $pSqlVersion}).pKey;
            if(!$productKey) {
$productKey = 'your product key here';
            } else { Write-Host "Product Key = {$productKey}" -ForegroundColor Cyan;}
            if([string]::IsNullOrEmpty($productKey)) {
                Write-Host "You forgot to mention the product Key";
                exit;
            }
        }
    }
}

# Derived Variables
Copy-Item "$SqlSetupInventoryPath\$pSqlVersion\$SqlEdition\SqlServer_$($pSqlVersion)_$SqlEdition.ISO" -Destination 'C:\TEMP';
$SetupISOImagePath = "C:\TEMP\SqlServer_$($pSqlVersion)_$SqlEdition.ISO";
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

try {
    $OutputVariable = cmd.exe /c "Setup.exe /QS /ACTION=Install /ENU /IACCEPTSQLSERVERLICENSETERMS /UpdateEnabled=0 /FEATURES=$pFeatureParameters /INSTANCENAME=$pInstanceName /SQLSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /SQLSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /AGTSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCSTARTUPTYPE=Automatic /SQLSYSADMINACCOUNTS=$pSqlSysAdminAccounts /PID=$productKey /INSTALLSQLDATADIR=$pInstanceRootDirectory /SQLUSERDBDIR=$pSqlDataDirectory /SQLUSERDBLOGDIR=$pSqlLogDirectory /SQLTEMPDBDIR=$pSqlTempDbDirectory /SQLTEMPDBLOGDIR=$pSqlTempDbDirectory /SQLBACKUPDIR=$pSqlBackupDirectory /BROWSERSVCSTARTUPTYPE=Automatic /SECURITYMODE=SQL /SAPWD=$pSqlSAPassword /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /TCPENABLED=1 /HIDECONSOLE" | Out-String;
}
catch {
    $formatstring = "{0} : {1}`n{2}`n" +
                "    + CategoryInfo          : {3}`n" +
                "    + FullyQualifiedErrorId : {4}`n"
    $fields = $_.InvocationInfo.MyCommand.Name,
              $_.ErrorDetails.Message,
              $_.InvocationInfo.PositionMessage,
              $_.CategoryInfo.ToString(),
              $_.FullyQualifiedErrorId

    $formatstring -f $fields
    Write-Host ($_.Exception.Message) -ForegroundColor Red;
}
finally {
    # Eject/Unmount ISO Image
    Dismount-DiskImage -ImagePath $SetupISOImagePath;
}

if($OutputVariable -like "*Error*" -or [string]::IsNullOrEmpty($OutputVariable)) {
    Write-Host $OutputVariable -ForegroundColor Red;
} else {
    Write-Host "Setup Completed Successfully." -ForegroundColor Green;
}

<# # Message in case of Failure
The following error occurred:
No features were installed during the setup execution. The requested features m
ay already be installed. Please review the summary.txt log for further details.

Error result: -2068643838
Result facility code: 1203
Result error code: 2

Please review the summary.txt log for further details
Microsoft (R) SQL Server 2014 12.00.2000.08

Copyright (c) Microsoft Corporation.  All rights reserved.

#>
