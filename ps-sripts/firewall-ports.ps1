# Network Discovery
netsh advfirewall firewall set rule group=”Virtual Machine Monitoring” new enable=yes
netsh advfirewall firewall set rule group=”network discovery” new enable=yes

netsh advfirewall firewall add rule name="Microsoft iSCSI Software Target Service-TCP-3260" dir=in action=allow protocol=TCP localport=3260
netsh advfirewall firewall add rule name="Microsoft iSCSI Software Target Service-TCP-135" dir=in action=allow protocol=TCP localport=135

New-NetFirewallRule -DisplayName "Sql Server (TCP/1433)" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow -Profile Any
New-NetFirewallRule -DisplayName "SQL Browser (UDP/1434)" -Direction Inbound -LocalPort 1434 -Protocol UDP -Action Allow -Profile Any
New-NetFirewallRule -DisplayName "SQL DAC (TCP/1434)" -Direction Inbound -LocalPort 1434 -Protocol TCP -Action Allow -Profile Any
New-NetFirewallRule -DisplayName "Sql Server HADR (TCP/5022)" -Direction Outbound -LocalPort 5022 -Protocol TCP -Action Allow -Profile Any

