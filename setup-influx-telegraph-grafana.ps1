https://docs.influxdata.com/influxdb/v2.0/get-started/?t=Linux
https://devconnected.com/how-to-setup-telegraf-influxdb-and-grafana-on-linux/
https://portal.influxdata.com/downloads/
https://www.howtoforge.com/tutorial/how-to-install-tig-stack-telegraf-influxdb-and-grafana-on-ubuntu-1804/

sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -

source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt update
sudo apt install influxdb -y

wget https://dl.influxdata.com/influxdb/releases/influxdb2-2.0.4-amd64.deb
sudo dpkg -i influxdb2-2.0.4-amd64.deb

# ransport=http addr=:8086 port=8086
