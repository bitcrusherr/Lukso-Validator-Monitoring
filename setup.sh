clear
green='\033[0;32m'
PINK="\033[35m"
nocolor='\033[0m'
logname=$(logname)
echo $green
echo -----------------------------------------------------------
echo
echo           "Bitcrusher's Dash Install v0.03"
echo
echo -----------------------------------------------------------
echo $PINK
echo
echo "welcome $logname."
echo
echo "Following applications can be installed:"
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
read -p "Install Promethues? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
prometheus="y"
echo "installing Promethues"
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz --directory-prefix "/home/$logname"
sudo mkdir /home/$logname/prometheus/
sudo tar xvfz /home/$logname/prometheus-2.44.0.linux-amd64.tar.gz -C /home/$logname/prometheus/
sudo rm prometheus-2.44.0.linux-amd64.tar.gz
echo
echo "Creating system service"
echo
sleep 1s
sudo printf "[Unit]\nDescription=prometheus\n\n[Service]\nExecStart=/home/$logname/prometheus\prometheus\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl enable prometheus.service
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
echo
echo "Creating system service"
echo
sleep 1s
sudo printf "[Unit]\nDescription=node-exporter\n\n[Service]\nExecStart=/home/$logname/node_exporter-1.5.0.linux-386\node_exporter\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/node-exporter.service
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
echo
echo "Creating system service"
echo
sleep 1s
sudo printf "[Unit]\nDescription=json-exporter\n\n[Service]\nExecStart=/home/$logname/json_exporter\json_exporter --config.file=/etc/json_exporter/json_exporter.yaml\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/json-exporter.service
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
echo
echo "Creating system service"
echo
sleep 1s
sudo printf "[Unit]\nDescription=blackbox-exporter\n\n[Service]\nExecStart=/home/$logname/blackbox_exporter-0.23.0.linux-amd64/blackbox_exporter\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/blackbox-exporter.service
Y_N=n
done

if [ -f "/home/$logname/prometheus-2.44.0.linux-amd64/promethues.yml" ];then
	sudo mv promethues.yml.old
fi
sudo wget https://raw.githubusercontent.com/bitcrusherr/Lukso-Validator-Monitoring/main/promethues.yml --directory-prefix "/home/$logname/prometheus-2.44.0.linux-amd64"


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
