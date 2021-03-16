# importing os module
import os, platform, json, re

'''
with open(setting_file) as f:
    setting = json.load(f)
print(setting)
'''

class VirtualMachineTemplate():
    # Class attributes
    default_machine_folder = None
    path_separator = "\\"

    def __init__(self,vm_name):
        self.vm_name = vm_name
        VirtualMachineTemplate.default_machine_folder = self.__find_default_machine_folder()
        self.__set_path_separator()
        self.template_file = f'{self.default_machine_folder}{self.path_separator}{self.vm_name}-vboxtools-template.json'

    def generate_template(self):
        pass

    def __find_default_machine_folder(self):
        stream = os.popen('VBoxManage list systemproperties | grep "Default machine folder:"')
        output = stream.readline()
        m = re.match(r"^Default machine folder:\s+(?P<machine_folder>.+)", output)
        return m.group('machine_folder')

    def __set_path_separator(self):
        if(platform.sys.platform == 'linux'):
            VirtualMachineTemplate.path_separator = '/'


class Disk():
    def __init__(self,filepath,size_gb=20):
        self.filepath = filepath
        self.size_gb = size_gb

    def create(self):
        cmd = f'VBoxManage createmedium disk --filename {self.filepath} --size {self.size_gb * 1024}'
        #os.system(cmd)
        print(cmd)
        result = os.system(cmd)
        if result == 0:
          return True
        else:
          return False


class VirtualMachine(VirtualMachineTemplate):
    """[summary]

    Returns:
        [type]: [description]
    """

    def __init__(self,vm_name):
        VirtualMachineTemplate.__init__(self,vm_name)

    def __str__(self):
        return f'Object for VM [{self.vm_name}]'

    def get_disk(self):
        pass

    def get_adapter(self):
        pass

    def add_adapter(self):
        pass

    def generate_setting_file(self):
        pass

    def validate_setting_file(self):
        pass

    def create(self):
        pass

    def start(self):
        pass

    def pause(self):
        pass

    def delete(self):
        pass


#type(my_vm)
#print(my_vm)

#disk_01 = Disk(filepath=f'{default_machine_folder}{path_separator}{args.vm_name}{path_separator}{args.vm_name}_disk01.vdi',size_gb=20)
#disk_01.create()


#VBoxManage createvm --name vm_name --ostype "Windows2016_64" --register

if __name__ == '__main__':
    print(f"Module script file '{os.path.basename(__file__)}' called")

