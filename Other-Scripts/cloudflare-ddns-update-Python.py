import socket
from cloudflare_ddns import CloudFlare
# https://pypi.org/project/cloudflare-ddns/
# GDrive -> Websites > sqlmonitor.ajaydwivedi.com > cloudflare-ddns-update-Python.py

api_key = "cloudflare_api_key"
sqlmonitor_subdomain = "sqlmonitor.ajaydwivedi.com"
email = "cloudflare_email_id"
noip_domain = 'noip_temp_domain'

new_ip_address = socket.gethostbyname(noip_domain)
print(f'new_ip_address => {new_ip_address}')

cf = CloudFlare(email, api_key, sqlmonitor_subdomain)
old_ip_address = cf.get_record('A', sqlmonitor_subdomain)

if old_ip_address == new_ip_address:
  print("Update of ip address is required.")
  cf.update_record('A',sqlmonitor_subdomain,new_ip_address)
else:
  print("Active ip address is correct.")
