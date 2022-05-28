# Spice agent for Linux
sudo apt install spice-vdagent


# Space Guest
  https://www.spice-space.org/download.html#guest
https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe

cd '/fast-storage-01/virtual-machines/Lab.com - Clients/Workstation'
sudo qemu-img convert -p -f qcow2 ./Workstation_H_Data.qcow2 -O qcow2 ./Workstation_H_Data-Shrinked.qcow2
sudo qemu-img convert -p -f qcow2 ./Workstation_H_Drive.qcow2 -O qcow2 ./Workstation_H_Drive-Shrinked.qcow2