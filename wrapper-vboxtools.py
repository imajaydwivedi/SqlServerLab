# importing os module
import os, platform, json, argparse, re
from pathlib import Path
def verbose(text):
    print(stylize(text, colored.fg('cyan')))
def error(text):
    print(stylize(text, colored.fg('red')))
def success(text):
    print(stylize(text, colored.fg('green')))
from vboxtools import VirtualMachine, VirtualMachineRegister, Disk

parser = argparse.ArgumentParser(description='Create virtual box vm')
parser.add_argument('-n', '--vm_name', type=str, metavar='', required=True, help='Name of virtual machine')
parser.add_argument('-v', '--verbose', action='store_true', help='print details log messages')
group = parser.add_mutually_exclusive_group()
group.add_argument('-c','--create', action='store_true', help='Create virtual machine from template')
group.add_argument('-t','--generate_template', action='store_true', help='Generate virtual machine template')
args = parser.parse_args()

if __name__ == '__main__':
    if (args.verbose):
        print(f"Module script file '{os.path.basename(__file__)}' called")

    myvm = VirtualMachine('SQL-J')
    if (args.verbose):
        print(myvm)

    if (args.generate_template):
        template_dict = {
            "Name": "SQL-J",
            "Machine folder": "/study-zone/virtual-machines",
            "OsType": "Windows2016_64",
            "Cpu": 2,
            "RAM": "2048",
            "Disks": [
                {"name":"c_drive", "size":20, "mount":"C:\\"},
                {"name":"d_drive", "size":20, "mount":"D:\\"},
                {"name":"e_drive", "size":20, "mount":"E:\\"},
                {"name":"data01_drive", "size":20, "mount":"E:\\data01\\"},
                {"name":"data02_drive", "size":20, "mount":"E:\\data02\\"},
                {"name":"log01_drive", "size":5, "mount":"E:\\log01\\"},
                {"name":"log02_drive", "size":5, "mount":"E:\\log02\\"},
                {"name":"tempdb_drive", "size":5, "mount":"E:\\tempdb\\"},
                {"name":"backup01_drive", "size":5, "mount":"E:\\backup01\\"},
                {"name":"backup02_drive", "size":5, "mount":"E:\\backup02\\"}
            ]
        }
        print(f"Default machine folder is : {myvm.default_machine_folder}")
        template_file = Path(myvm.template_file)
        if (template_file.exists()):
            print(f"Kindly remove existing template file '{myvm.template_file}'")
        else:
            with open(myvm.template_file,'w') as json_file:
                json_data = json.dumps(template_dict, indent=4)
                json_file.writelines(json_data)
            #print(json.dumps(template_dict))
            print(f"Template file is : {myvm.template_file}")