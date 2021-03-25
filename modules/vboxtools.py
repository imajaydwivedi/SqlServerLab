# importing os module
import os, platform, json, re

'''
with open(setting_file) as f:
    setting = json.load(f)
print(setting)
'''

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

class VirtualMachine():
    """[summary]

    Returns:
        [type]: [description]
    """

    def __init__(self,name):
        self.name = name
        self.props = self.__get_vm_info()

    def __str__(self):
        return f'Object for VM [{self.name}]'

    def __get_vm_info(self):
        stream = os.popen(f'VBoxManage showvminfo "{self.name}" --machinereadable')
        output = stream.readlines()
        return {((ln.strip()).split('='))[0]:((ln.strip()).split('='))[1] for ln in output}

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

class VirtualMachineRegister():
    """
        Library of VirtualBox virtual machines

        INPUT:

        OUTPUT:

        EXAMPLE: Get all supported OsTypes
            vm_register = VirtualMachineRegister()
            [print(item['ID']) for item in vm_register.get_ostypes()]
            print(", ".join( [item['ID'] for item in vm_register.get_ostypes()] ))

        EXAMPLE: Fetch next vm
            vm_register = VirtualMachineRegister()
            vm = next(vm_register);
            print(vm.name)

        EXAMPLE: Find VM with keyword in name
            vm_register = VirtualMachineRegister()
            [print(vm.name) for vm in vm_register.get_vm_by_name('SQL-')]

        EXAMPLE: Find supported OsType with keyword in ID
            vm_register = VirtualMachineRegister()
            [print(ot) for ot in vm_register.get_ostype_by_name('linux')]

        EXAMPLE: Search OsType by attributes
            vm_register = VirtualMachineRegister()
            
            print(f"\\nfind by condition => ID\\n")
            r = vm_register.search_ostype(lambda ot : 'linux' in ot['ID'].lower())
            [print(ot) for ot in r]

            print(f"\\nfind by condition => Description\\n")
            r = vm_register.search_ostype(lambda ot : 'windows 2016' in ot['Description'].lower())
            [print(ot) for ot in r]
    """

    def __init__(self):
        self.__ostypes = self.__detect_ostypes()
        self.__vms = self.__detect_existing_vms()
        self.default_machine_folder = self.__find_default_machine_folder()
        self.__path_separator = self.__get_path_separator()
        self.__counter = -1
        #self.template_file = f'{self.default_machine_folder}{self.path_separator}{self.vm_name}-vboxtools-template.json'

    def __detect_existing_vms(self):
        stream = os.popen('VBoxManage list vms')
        output = stream.readlines()
        vms = {}
        for ln in output:
            line = ln.strip()
            m = re.match(r'^"(?P<vm_name>[A-Za-z0-9-_]*)"\s\{[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}\}$', line)
            vm_name = m.group('vm_name')
            vm = VirtualMachine(vm_name)
            #self.vms.append(vm)
            vms[vm.name] = vm
        return vms

    def __detect_ostypes(self):
        stream = os.popen('VBoxManage list ostypes')
        output = stream.readlines()

        index = 0
        ostypes = {}
        while index < len(output):
            os_type_line = [ line.strip() for line in output[index:index+5] ]
            os_type = { (x.split(':',1)[0]).strip() : (x.split(':',1)[1]).strip() for x in os_type_line }
            #ostypes.append(os_type)
            ostypes[os_type['ID']] = os_type
            index += 6

        return ostypes

    def get_vms(self):
        return self.__vms.values()

    def get_ostypes(self):
        return self.__ostypes.values()

    def generate_template(self):
        pass

    def __find_default_machine_folder(self):
        stream = os.popen('VBoxManage list systemproperties | grep "Default machine folder:"')
        output = stream.readline()
        m = re.match(r"^Default machine folder:\s+(?P<machine_folder>.+)", output)
        return m.group('machine_folder')

    def __get_path_separator(self):
        path_separator = "\\"
        if(platform.sys.platform == 'linux'):
            path_separator = '/'
        return path_separator

    def __iter__(self):
        return self

    def __next__(self):
        if self.__counter >= len(self.__vms):
            raise StopIteration
        else:
            self.__counter += 1
        #return self.vms[self.__counter]
        return [vm for index,vm in enumerate(self.__vms.values()) if index == self.__counter][0]

    def get_vm_by_name(self,keyword):
        r = [self.__vms[name] for name in self.__vms.keys() if keyword.lower() in name.lower()]
        if len(r) == 0:
            return None
        else:
            return r

    def search_vm(self,condition):
        pass

    def get_ostype_by_name(self,keyword):
        r = [self.__ostypes[otid] for otid in self.__ostypes.keys() if keyword.lower() in otid.lower()]
        if len(r) == 0:
            return None
        else:
            return r

    def search_ostype(self,condition):
        return [ot for ot in self.__ostypes.values() if condition(ot)]



#type(my_vm)
#print(my_vm)

#disk_01 = Disk(filepath=f'{default_machine_folder}{path_separator}{args.vm_name}{path_separator}{args.vm_name}_disk01.vdi',size_gb=20)
#disk_01.create()


#VBoxManage createvm --name vm_name --ostype "Windows2016_64" --register

if __name__ == '__main__':
    r = os.system('clear')

    print(f"*** Module script file '{os.path.basename(__file__)}' called ***")
    print('******************************************************************')
    vm_register = VirtualMachineRegister()
    help(vm_register)
    #[print(ot) for ot in vm_register.get_ostype_by_name('linux')]
    #[print(vm.name) for vm in vm_register.get_vm_by_name('SQL-')]






