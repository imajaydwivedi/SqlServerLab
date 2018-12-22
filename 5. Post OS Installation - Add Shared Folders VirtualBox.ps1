#$machines = @('DC','SQL-A','SQL-B','SQL-C','SQL-D','SQL-E','SQL-F','SQL-G');
$machines = @('SQL-A')
$host_Softwares = 'E:\Softwares';
$host_Downloads = 'C:\Users\adwivedi\Downloads'

foreach($vm in $machines)
{
    # Add shared folders
    VBoxManage sharedfolder add $vm --name Host_Softwares --hostpath $host_Softwares --automount;
    VBoxManage sharedfolder add $vm --name Host_Downloads --hostpath $host_Downloads --automount;

    # Configuring a Virtual Network Adapter
        # Bridged Adapter
    VBoxManage modifyvm $vm --nic2 bridged
        # NAT
    #VBoxManage modifyvm $vm --nic3 nat
}

# Change IP of machine for Host-Only Adapter
netsh int ip set address "Ethernet 2" address=192.168.1.20 mask=255.255.255.0 gateway=192.168.1.1
Netsh interface ipv4 set dnsservers "Ethernet 2" static 8.8.8.8 primary
netsh interface ip add dns “Ethernet 2" 8.8.4.4 index=2

