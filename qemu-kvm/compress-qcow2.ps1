$path = "/fast-storage-01/virtual-machines/Lab.com - Clients/Workstation"
#$path = "/fast-storage-01/virtual-machines/Lab.com - Distributors"
$files = @()
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Find all files on '$path'.."
$files += Get-ChildItem $path *.qcow2 -Recurse -File | Where-Object {$_.Size -gt 50000000000} # 50 gb

$filesFiltered = @()
$filesFiltered += $files | Where-Object {$_.Name -notin @('Workstation.qcow2','')}

#$filesFiltered[0] | Select-Object *

cls
foreach($file in $filesFiltered) {
  #if($file.Name -like 'DC*') {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working with '$($file.Name)'.."

    $originalFileName = $file.BaseName
    $renamedFileName = "$Old- originalFileName"
    $fileDirectory = $file.Directory;
    Rename-Item -Path "$fileDirectory/$originalFileName.qcow2" "$fileDirectory/$renamedFileName.qcow2"

    sudo qemu-img convert -p -f qcow2 "$fileDirectory/$renamedFileName.qcow2" -O qcow2 "$fileDirectory/$originalFileName.qcow2"

  #}
}