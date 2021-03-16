# importing os module
import os

# Create global variables
VIRTUAL_MACHINE_FOLDER = '/study-zone/virtual-machines'

# Display variables
print(f"Directory of Virtual Machines is '{VIRTUAL_MACHINE_FOLDER}'")

# Display all folders
vm_directories = os.listdir(VIRTUAL_MACHINE_FOLDER)
print(vm_directories)
