clear
green='\033[0;32m'
PINK="\033[35m"
nocolor='\033[0m'
logname=$(logname)
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
echo "Note, this isnt 100% my work this is just gathering everything"
echo "togehtor in one package to hopefully make it easier for everyone"
echo "any problems please contact me on discord Bitcrushe#4049 with"
echo "problems or fixes thanks."
echo
read -p "Press Enter to continue....." enter

#Key tools needed
sudo apt install wget make git apt-transport-https software-properties-common gnupg2

echo 
read -p "Install Promethues? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
echo "installing Promethues"
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz --directory-prefix "/home/$logname"
sudo tar xvfz /home/$logname/prometheus-2.44.0.linux-amd64.tar.gz
sudo rm prometheus-2.44.0.linux-amd64.tar.gz
Y_N=n
done

echo 
read -p "Install Grafana? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
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
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-386.tar.gz --directory-prefix "/home/$logname"
sudo tar xvfz /home/$logname/node_exporter-1.5.0.linux-386.tar.gz
sudo rm node_exporter-1.5.0.linux-386.tar.gz
Y_N=n
done

echo
read -p "Install JSON-exporter? (y = yes / n = no): " Y_N
while [ "$Y_N" = "y" ]; do
echo "insalling JSON-exporter"
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
