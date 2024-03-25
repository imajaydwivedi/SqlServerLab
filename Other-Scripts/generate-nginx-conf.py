import panda

# Excel On GDrive => Ajay Dwivedi > Statements & Bills > Broadband > Nginx - Airtel - Port Mapping - Port Forwarding.xlsx
# Excel on Local => ~/Github/Python-BootCamp/excel/Nginx - Airtel - Port Mapping - Port Forwarding.xlsx
dataframe1 = pd.read_excel('Nginx - Airtel - Port Mapping - Port Forwarding.xlsx',sheet_name='Port-Mapping')

# read each line, and generate nginx conf code
automatic_port = 50000
group_filter = 'ryzen9'
group_ip = '192.168.1.4'

upstream_text = ''
server_text = ''
nginx_conf_text = ''
for machine,ip,svc_name,i_port,p_port,group in dataframe1.values:
    rule_needed = True
    public_port = 0
    
    # Filter for a specific Linux Host Nginx Conf
        # Generate entry only when not host machine
    if group == group_filter and machine != group:        
        
        # remove special characters
        if machine.find("-") > 0:
            machine = machine.replace('-','_')
        
        if p_port in ('Public-Full-Automatic','Local-Automatic'):
            automatic_port += 1
            public_port = automatic_port
            
        if p_port == 'Public-Semi-Automatic':
            group_ip_last_no = group_ip.split('.')[-1]
            public_port = f"{group_ip_last_no}{i_port}"
        
        rule_name = f"{machine}__{svc_name}__{public_port}"

        if p_port != 'X':
            upstream_str = f"""
        upstream {rule_name} {{
            server {ip}:{i_port} weight=1;
        }}"""

            server_str = f"""
        server {{
            listen {public_port};
            proxy_pass {rule_name};
        }}"""

            #print(upstream_str)
            upstream_text += upstream_str
            #print(server_str)
            server_text += server_str
            
            nginx_conf_text = upstream_str + server_str
            print(nginx_conf_text)
            
            #break;
    
#print(upstream_text)
#print(server_text)