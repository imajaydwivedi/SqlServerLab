# Step 01:- Add Shared Folders
Host_E_Drive
    E:\

Host_Downloads
    C:\Users\adwivedi\Downloads

Host_Softwares
    G:\SQL_Server_Setups

# Step 02:- Add Bridged Adapter (Ethernet 2)

# Step 03:- Start VM

# Step 04:- Copy "SQL_Server_Setups" to D:\ Drive of DC.Contso.com. For other machines, skip this step

# Step 06:- Execute below command to install Windows Management Framework
\\DC\SQL_Server_Setups\WMF\2012R2\WMF_2012R2.msu /quiet

# Step 07:- Once VM is backup after reboot, run below query to Set Timezone
Set-TimeZone -Id 'India Standard Time'

# Step 08:- # Change IP of machine for Bridged Adapter
New-NetIPAddress –InterfaceAlias “Ethernet 2” –IPAddress “192.168.1.30” –PrefixLength 24 -DefaultGateway 192.168.1.1
Netsh interface ipv4 set dnsservers "Ethernet 2" static 8.8.8.8 primary
netsh interface ip add dns “Ethernet 2" 8.8.4.4 index=2
