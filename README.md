# Lukso-Validator-Monitoring (This is not 100% complete)


Monitor your lukso validator using a few apps put together and using a prebuilt modified grafana dashboard!
linux systems only

Run setup.sh to install but not fully configure the following services / applications:

Grafana

Prometheus

Node-Exporter

JSON-Exporter

Blackbox_Exporter

# Instructions:

1 - Run setup.sh and follow on screen instructions ( sudo wget https://raw.githubusercontent.com/bitcrusherr/Lukso-Validator-Monitoring/main/setup.sh && sudo sh setup.sh ) Without brackets

2 - Import the dashboard.json to grafana (if you receive N/A over the dash thats because the data store id is not the same as mine and you will need to edit it in the .json to suit)

3 - Setup grafana to connect to datastore promethues

4 - after completing install check services are running example: sudo systemctl status promethues.service

# Trouble Shooting
If you are missing information or its not displayed correctly chances are the service isnt started or
there is a problem with the configuration, which could either be the prometheus.yml or even the information
promethues is able to grab.

You can check the query information and see the data grafana is pulling from prometheus and than check promethues to 
see if the data is coming up correclty there.

You may also find there are system metrics which come from different areas and require different queries,
this is done by just searching promethues for the one that suits your system.

If you are running on a vm / vps chances are some system metrics will not be available for example tempretures
