# EXPOSE your home network to the INTERNET
    # https://www.youtube.com/watch?v=ey4u7OUAF3c

# Download Cloudflare utility
https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/#latest-release

# download "Cloudflare Zero Trust", paste is in PATH directory. Then access the tunnel using below command
cloudflared access tcp --hostname postgres.ajaydwivedi.com --url localhost:5432


psql -h postgres.ajaydwivedi.com -U rreddy -d yourdatabase -p 5432

# create tunnel on host with postgres installed
cloudflared tunnel --hostname postgres.ajaydwivedi.com --url tcp://localhost:5432

# download "Cloudflare Zero Trust", paste is in PATH directory. Then access the tunnel using below command
cloudflared access tcp --hostname postgres.ajaydwivedi.com --url localhost:5432

