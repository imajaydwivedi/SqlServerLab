$ServerName = $env:COMPUTERNAME;

# https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/enable-or-disable-a-server-network-protocol?view=sql-server-2014
$wmi = new-object ('Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer');

# List the object properties, including the instance names.  
$ServerInstances = $Wmi.GetSmoObject("ManagedComputer[@Name='$ServerName']").ServerInstances;
$counter = 0;
$Ports_used = @(); # Initialize Ports Used
foreach($Instance in $ServerInstances) { $port = $Instance.ServerProtocols['Tcp'].IPAddresses['IPAll'].IPAddressProperties['TcpPort'].Value;  if($port) { $Ports_used += $port; }}
foreach($Instance in $ServerInstances)
{
    # Part 01 => Check if TCP/IP Protocol is Enabled
    $InstanceName = $Instance.Name;
    $TcpObj = $Instance.ServerProtocols['Tcp'];
    Write-Host "$InstanceName" -BackgroundColor Green;
    
    if($TcpObj.IsEnabled -eq $false) { # Enable the Tcp Protocol
        $TcpObj.IsEnabled = $true;
        Write-Host "Tcp protocol has been enabled for SqlInstance [$ServerName\$InstanceName]";
    }

    $Port = $TcpObj.IPAddresses['IPAll'].IPAddressProperties['TcpDynamicPorts'].Value; 
    if($Port) {
        $TcpObj.IPAddresses['IPAll'].IPAddressProperties['TcpDynamicPorts'].Value = "";
        Write-Host "Dynamic port value is removed for IpAll";
    }

    # Part 02 => Check if TCP/IP Port is assigned
    $pSqlPortNo = 1433;
    $PortNo = $TcpObj.IPAddresses['IPAll'].IPAddressProperties['TcpPort'].Value; 
    if(!$PortNo) 
    { # If Tcp Port is not assigned for IpAll of SqlInstance, then assign the port
        if ($pInstanceName -ne 'MSSQLSERVER') { # Calculate port no
            $counter += 1;
            $pSqlPortNo -= $counter;
        }

        # Make sure of not using used ports
        while($pSqlPortNo -in $Ports_used) {
            $counter += 1;
            $pSqlPortNo -= $counter;
        }
        $TcpObj.IPAddresses['IPAll'].IPAddressProperties['TcpPort'].Value = [String]$pSqlPortNo;
        Write-Host "Tcp port $pSqlPortNo has been set for SqlInstance [$ServerName\$InstanceName]";
    } 
    else 
    {
        $pSqlPortNo = $PortNo;
        Write-Host "Tcp port $pSqlPortNo is ALREADY assigned for SqlInstance [$ServerName\$InstanceName]";
    }
    $Ports_used += $pSqlPortNo;  

    # Save changes
    $TcpObj.Alter();

    # Part 03 => Enabling SQL Server Ports
    $rules = Get-NetFirewallRule -DisplayName “SQL Server ($InstanceName)” -ErrorAction SilentlyContinue;
    if ($rules -eq $null) {
      New-NetFirewallRule -DisplayName “SQL Server ($InstanceName)” -Direction Inbound –Protocol TCP –LocalPort $pSqlPortNo -Action allow;
      Write-Host "Port '$pSqlPortNo' opened for `"$InstanceName`" instance";
    }
    else {
      Write-Host "Port '$pSqlPortNo' is already opened for `"$InstanceName`" instance";
    }

    # Part 04 => Restart Instance
    Restart-DbaService -ComputerName $ServerName -InstanceName $InstanceName -Type Engine -Force;
}

# If SqlInstances are found, then add other Firewall Rules
if($ServerInstances.Count) {
  Write-Host "Adding Other rules";

  # Set-ExecutionPolicy -ExecutionPolicy RemoteSigned;

  #Enabling SQL Server Ports
  $ruleName = “SQL Admin Connection”;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { $r = New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol TCP –LocalPort 1434 -Action allow; }

  $ruleName = “SQL Database Management";
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { $r = New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol UDP –LocalPort 1434 -Action allow; }

  $ruleName = “SQL Service Broker”;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { $r = New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol TCP –LocalPort 4022 -Action allow; }

  $ruleName = “SQL Debugger/RPC”;
  $rules = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue;
  if ($rules -eq $null) { $r = New-NetFirewallRule -DisplayName $ruleName -Direction Inbound –Protocol TCP –LocalPort 135 -Action allow; }

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