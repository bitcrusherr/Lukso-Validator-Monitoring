clear
green='\033[0;32m'
PINK="\033[35m"
nocolor='\033[0m'
logname=$(logname)
skipquestions=n
echo $green
echo -----------------------------------------------------------
echo
echo           "Bitcrusher's Dash Install"
echo
echo -----------------------------------------------------------
echo $PINK
echo
echo "welcome $logname."
echo
echo "Can install following:"
echo
echo "Prometheus"
echo "Grafana"
echo "Node-exporter"
echo "json-exporter"
echo "blackbox-exporter"
echo
read -p "Press Enter to continue....." enter

#Key tools needed
sudo apt install wget make git apt-transport-https software-properties-common gnupg2

echo
while -p [ "$skipquestions" = "n" ]; do
read -p "Install Promethues? (y = yes / n = no): " Y_N
done
while [ "$Y_N" = "y" || "$installall" = "y" ]; do
prometheus="y"
echo "installing Promethues"
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz --directory-prefix "/home/$logname"
sudo tar xvfz /home/$logname/prometheus-2.44.0.linux-amd64.tar.gz
sudo rm prometheus-2.44.0.linux-amd64.tar.gz
Y_N=n
done

echo 
read -p "Install Grafana? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
grafana="y"
echo "installing Grafana"
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
$(sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key)
$(sudo echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list)
sudo apt-get update
sudo apt-get install grafana
Y_N=n
done

echo
read -p "Install node-exporter? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
echo "installing node-exporter"
node-exporter="y"
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-386.tar.gz --directory-prefix "/home/$logname"
sudo tar xvfz /home/$logname/node_exporter-1.5.0.linux-386.tar.gz
sudo rm node_exporter-1.5.0.linux-386.tar.gz
Y_N=n
done

echo
read -p "Install JSON-exporter? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
echo "insalling JSON-exporter"
json-exporter="y"
sudo wget https://dl.google.com/go/go1.20.4.linux-amd64.tar.gz --directory-prefix "/home/$logname/"
sudo tar xfv /home/$logname/go1.20.4.linux-amd64.tar.gz
sudo mv /home/$logname/go /usr/local/go-1.20.4
sudo ln -sf /usr/local/go-1.20.4/bin/go /usr/bin/go
sudo go version
sleep 1s
sudo rm /home/$logname/go1.20.4.linux-amd64.tar.gz
sudo git clone https://github.com/prometheus-community/json_exporter.git /home/$logname/json_exporter
sudo make build --directory="/home/$logname/json_exporter"
if [ -d "/etc/json_exporter/" ];then
	sudo rm /etc/json_exporter/ -r
fi
sudo mkdir /etc/json_exporter/
sudo printf "modules:\n  default:\n    metrics:\n    - name: lyxeur\n      path: \"{.lukso-token.usd}\"\n      help: LUKSO (LYX) Price in USD" >> /etc/json_exporter/json_exporter.yaml
Y_N=n
done

echo
read -p "Install BlackBox-exporter? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
echo "installing BlackBox-exporter"
blackbox-exporter="y"
sudo wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-amd64.tar.gz --directory-prefix "/home/$logname"
sudo tar xvfz /home/$logname/blackbox_exporter-0.23.0.linux-amd64.tar.gz
sudo rm blackbox_exporter-0.23.0.linux-amd64.tar.gz
sudo setcap cap_net_raw+ep /home/$logname/blackbox_exporter
if [ -d "/etc/blackbox_exporter/" ];then
	sudo rm /etc/blackbox_exporter/ -r
fi
sudo mkdir /etc/blackbox_exporter/
sudo printf "modules:\n  icmp:\n    prober: icmp\n    timeout: 10s\n    icmp:\n      preferred_ip_protocol: ipv4" >> /etc/blackbox_exporter/blackbox.yaml
Y_N=n
done

if [ -f "/home/$logname/prometheus-2.44.0.linux-amd64/promethues.yml" ];then
	sudo mv promethues.yml.old
fi
sudo wget https://raw.githubusercontent.com/bitcrusherr/Lukso-Validator-Monitoring/main/promethues.yml --directory-prefix "/home/$logname/prometheus-2.44.0.linux-amd64"

echo
echo "Creating system services"
echo
sleep 1s

while [ "prometheus" = "y"]; do
sudo printf "[Unit]\nDescription=prometheus\n\n[Service]\nExecStart=/home/$logname/prometheus-2.44.0.linux-amd64\prometheusn\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/prometheus.service
done

while [ "node-exporter" = "y"]; do
sudo printf "[Unit]\nDescription=node-exporter\n\n[Service]\nExecStart=/home/$logname/node_exporter-1.5.0.linux-386\node_exporter\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/node-exporter.service
done

while [ "json-exporter" = "y"]; do
sudo printf "[Unit]\nDescription=json-exporter\n\n[Service]\nExecStart=/home/$logname/json_exporter\json_exporter --config.file=/etc/json_exporter/json_exporter.yaml\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/json-exporter.service
done

while [ "blackbox-exporter" = "y"]; do
sudo printf "[Unit]\nDescription=blackbox-exporter\n\n[Service]\nExecStart=/home/$logname/blackbox_exporter-0.23.0.linux-amd64/blackbox_exporter\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/blackbox-exporter.service
done

echo $green
echo -----------------------------------------------------------
echo
echo           "Bitcrusher's Dash Install"
echo
echo -----------------------------------------------------------
echo $nocolor
echo
echo "Finished, follow install instructions on github for remaining steps"
echo 

sudo rm setup.sh
