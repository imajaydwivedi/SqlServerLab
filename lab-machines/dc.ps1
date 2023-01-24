# Get network Adapters. Rename network adapters if required.
netsh interface show interface

# Set static IP for both adapters
netsh interface ipv4 set address "Ethernet 1" static 192.168.100.10
netsh interface ipv4 set address "Ethernet 2" static 192.168.200.10

# Rename computer
netdom renamecomputer %computername% /newname:SQLMonitor


