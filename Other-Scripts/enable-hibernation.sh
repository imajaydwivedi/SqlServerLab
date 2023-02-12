# https://www.linuxuprising.com/2021/08/how-to-enable-hibernation-on-ubuntu.html
# Enable hybernate option

# Find out UUID of disk contining Swap File
swapon --show # Note swap file location & use in below command
findmnt -no UUID -T /hyper-active/swapfile.img
# 4ab3a57f-7a48-4d3b-8db6-4015be68981e

# Find out the swap file offset
sudo filefrag -v /hyper-active/swapfile.img
# 163479552

