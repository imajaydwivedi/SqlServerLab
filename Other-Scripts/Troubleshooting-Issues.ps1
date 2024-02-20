# Issue# 01 - JBL Bluetooth not connecting
https://askubuntu.com/a/1408452/1015062

sudo apt-get install blueman
sudo /etc/init.d/bluetooth start

sudo apt-get update -y
sudo apt-get install -y bluez-tools

# Issue# 02 - Sharing folders on Windows Network
https://ubuntu-mate.community/t/sharing-folders-on-windows-network/2644

sudo apt install -y caja-share samba
reboot now

# Samba Share setup properly, and Windows not able to access
Error/Fix => https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/cannot-access-shared-folder-file-explorer#you-cant-access-this-shared-folder-because-your-organizations-security-policies-block-unauthenticated-guest-access
https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/cannot-access-shared-folder-file-explorer#:~:text=Method%202%3A%20Enable%20insecure%20guest%20logons%20with%20Local%20Group%20Policy%20Editor



# Change Nginx Port (other than 80)
  # https://stackoverflow.com/a/12800469
  