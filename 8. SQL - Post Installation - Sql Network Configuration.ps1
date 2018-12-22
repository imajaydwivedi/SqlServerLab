# Install SqlServer Powershell Module
Install-Module SqlServer -Scope AllUsers -Force -AllowClobber;
Install-Module dbatools -Scope AllUsers -Force -AllowClobber

#Configuring your TCP Port via Powershell

#Set-SqlNetworkConfiguration -Protocol TCP -ForceServiceRestart -AcceptSelfSignedCertificate;

# Parameters
$VerbosePreference = "Continue";
$ServerName = $env:COMPUTERNAME;

#$services = Get-Service -ComputerName $ComputerName -Name *sql*;
$services = Get-SqlInstance -MachineName $ServerName;

$counter = 0;
# Check if any DatabaseEngine SQLService is found
$isFound = if($services -ne $null) {$true} else {$false};

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
    $rules = Get-NetFirewallRule -DisplayName â€œSQL Server (MSSQLSERVER)â€ -ErrorAction SilentlyContinue
    if ($rules -eq $null) {
      New-NetFirewallRule -DisplayName â€œSQL Server ($pInstanceName)â€ -Direction Inbound â€“Protocol TCP â€“LocalPort $pSqlPortNo -Action allow;
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
  $ruleName = “SQL Admin Connection”;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol TCP –LocalPort 1434 -Action allow; }

  $ruleName = “SQL Database Management";
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol UDP –LocalPort 1434 -Action allow; }

  $ruleName = “SQL Service Broker”;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol TCP –LocalPort 4022 -Action allow; }

  $ruleName = “SQL Debugger/RPC”;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol TCP –LocalPort 135 -Action allow; }

  <#
    #Enabling SQL Analysis Ports
    New-NetFirewallRule -DisplayName â€œSQL Analysis Servicesâ€ -Direction Inbound â€“Protocol TCP â€“LocalPort 2383 -Action allow
    New-NetFirewallRule -DisplayName â€œSQL Browserâ€ -Direction Inbound â€“Protocol TCP â€“LocalPort 2382 -Action allow
    #Enabling Misc. Applications
    New-NetFirewallRule -DisplayName â€œHTTPâ€ -Direction Inbound â€“Protocol TCP â€“LocalPort 80 -Action allow
    New-NetFirewallRule -DisplayName â€œSSLâ€ -Direction Inbound â€“Protocol TCP â€“LocalPort 443 -Action allow
    New-NetFirewallRule -DisplayName â€œSQL Server Browse Button Serviceâ€ -Direction Inbound â€“Protocol UDP â€“LocalPort 1433 -Action allow
    #Enable Windows Firewall
    Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
    #>
}