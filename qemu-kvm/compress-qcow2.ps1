#$path = "/fast-storage-01/virtual-machines/Lab.com - Clients/Workstation"
$path = "/fast-storage-01/virtual-machines/Lab.com/SqlMonitor"
$files = @()
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Find all files on '$path' over 5MB.."
$files += Get-ChildItem $path *.qcow2 -Recurse -File | Where-Object {$_.Size -gt 5MB} # 50gb

$skipList = @()
$filesFiltered = @()
$onlyList = @()
$skipList += @('Workstation.qcow2','Workstation_E_Data.qcow2','Workstation_E_Log.qcow2','Workstation_E_TempDb2.qcow2',
              'Workstation_I_Drive.qcow2','Workstation_E_TempDb.qcow2','Workstation_J_Drive.qcow2','Workstation_E_Backup.qcow2',
              'Workstation_F_Drive.qcow2')
$onlyList += @('Workstation.qcow2')
#$filesFiltered += $files | Where-Object {$_.Name -notin $skipList}
#$filesFiltered += $files | Where-Object {$_.Name -in $onlyList}
$filesFiltered += $files

#$filesFiltered[0] | Select-Object *

cls
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Loop through found files and compress.." | Write-Host -ForegroundColor Yellow
foreach($file in $filesFiltered) {
  #if($file.Name -like 'DC*') {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working with '$($file.Name)'.." | Write-Host -ForegroundColor Cyan

    $originalFileName = $file.BaseName
    $renamedFileName = "Old-$originalFileName"
    $fileDirectory = $file.Directory;
    Rename-Item -Path "$fileDirectory/$originalFileName.qcow2" "$fileDirectory/$renamedFileName.qcow2"

    sudo qemu-img convert -p -f qcow2 "$fileDirectory/$renamedFileName.qcow2" -O qcow2 "$fileDirectory/$originalFileName.qcow2"

  #}
}