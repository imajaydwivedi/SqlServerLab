$path = "/fast-storage-01/virtual-machines/Lab.com - Mirroring"
#$path = "/fast-storage-01/virtual-machines/Lab.com - Distributors"
$files = @()
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Find all files on '$path'.."
$files += Get-ChildItem $path *.vdi -Recurse -File

$files | ft -AutoSize

cls
foreach($file in $files) {
  #if($file.Name -like 'DC*') {
    $vdiFile = $file.FullName
    $newFile = $vdiFile.Replace('.vdi','.qcow2')
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working with '$vdiFile'.."
    sudo qemu-img convert -f vdi -O qcow2 $vdiFile $newFile
  #}
}
