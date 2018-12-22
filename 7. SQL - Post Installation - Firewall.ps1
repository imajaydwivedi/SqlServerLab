# Parameters
$VerbosePreference = "Continue";
$ComputerName = $env:COMPUTERNAME;

$services = Get-Service -ComputerName $ComputerName -Name *sql*;

$counter = 0;
$isFound = $false;
# Check if any DatabaseEngine SQLService is found
foreach ($srv in $services) {
  if ($_.DisplayName -match "^SQL Server \(\w+\)$") {$isFound = $true; break; }
}

# Loop through DatabaseEngine Services, and open ports
foreach ($svc in $services) {
  # reset PortNo
  $pSqlPortNo = 1433;
  if ($svc.DisplayName -match "^SQL Server \((?'InstanceName'\w+)\)$") {
    $pInstanceName = $Matches['InstanceName'];

    # Increment Counter
    if ($pInstanceName -ne 'MSSQLSERVER') {
      $counter += 1;
      $pSqlPortNo -= $counter;
    }

    # Enabling SQL Server Ports
    $rules = Get-NetFirewallRule -DisplayName ‚ÄúSQL Server (MSSQLSERVER)‚Äù -ErrorAction SilentlyContinue
    if ($rules -eq $null) {
      New-NetFirewallRule -DisplayName ‚ÄúSQL Server ($pInstanceName)‚Äù -Direction Inbound ‚ÄìProtocol TCP ‚ÄìLocalPort $pSqlPortNo -Action allow;
      Write-Verbose "Port '$pSqlPortNo' opened for `"$pInstanceName`" instance";
    }
    else {
      Write-Verbose "Port '$pSqlPortNo' is already opened for `"$pInstanceName`" instance";
    }
  }
}

# If SQLServices are found, then open other ports as well
if ($isFound) {
  Write-Verbose "Adding Other rules";

  # Set-ExecutionPolicy -ExecutionPolicy RemoteSigned;

  #Enabling SQL Server Ports
  $ruleName = ìSQL Admin Connectionî;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound ñProtocol TCP ñLocalPort 1434 -Action allow; }

  $ruleName = ìSQL Database Management";
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound ñProtocol UDP ñLocalPort 1434 -Action allow; }

  $ruleName = ìSQL Service Brokerî;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound ñProtocol TCP ñLocalPort 4022 -Action allow; }

  $ruleName = ìSQL Debugger/RPCî;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound ñProtocol TCP ñLocalPort 135 -Action allow; }

  <#
    #Enabling SQL Analysis Ports
    New-NetFirewallRule -DisplayName ‚ÄúSQL Analysis Services‚Äù -Direction Inbound ‚ÄìProtocol TCP ‚ÄìLocalPort 2383 -Action allow
    New-NetFirewallRule -DisplayName ‚ÄúSQL Browser‚Äù -Direction Inbound ‚ÄìProtocol TCP ‚ÄìLocalPort 2382 -Action allow
    #Enabling Misc. Applications
    New-NetFirewallRule -DisplayName ‚ÄúHTTP‚Äù -Direction Inbound ‚ÄìProtocol TCP ‚ÄìLocalPort 80 -Action allow
    New-NetFirewallRule -DisplayName ‚ÄúSSL‚Äù -Direction Inbound ‚ÄìProtocol TCP ‚ÄìLocalPort 443 -Action allow
    New-NetFirewallRule -DisplayName ‚ÄúSQL Server Browse Button Service‚Äù -Direction Inbound ‚ÄìProtocol UDP ‚ÄìLocalPort 1433 -Action allow
    #Enable Windows Firewall
    Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
    #>
}