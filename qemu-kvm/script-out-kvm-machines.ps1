# Parameters
$configDirectory = "/home/saanvi/Github/SqlServerLab/kvm-vms-config"

# Get List of VMs
$vmListOutputRaw = virsh list --all

# Loop through raw VM Names list, Extract Vm Name, & Save Config
foreach ($line in $vmListOutputRaw[2..($vmListOutputRaw.Length - 2)])
{
  [String]$vmName = $null

  if($line -match "-\s*(?'vmName'[\w\s-]*)\s+shut off") {
    $vmName = $Matches['vmName'].Trim()
  }

  virsh dumpxml $vmName > "$configDirectory/$vmName.xml"
}


# virsh dumpxml SqlProd-GC > "/stale-storage/GitHub/SqlServerLab/kvm-vms-config/SqlProd-GC.xml"