import os, platform, json, re

stream = os.popen('VBoxManage list vms')
output = stream.readlines()
for ln in output:
    line = ln.strip()
    print(line)
    m = re.match(r'^"\[\w-\_\]*"\s', line)
    print(m)

[Current-Time-UTC], [Pool], [% CPU @Pool-Level], [% CPU @Server-Level], [% Schedulers@Total], [% Schedulers@Sql], [Assigned Schedulers]