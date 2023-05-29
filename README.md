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

1 - Run setup.sh and follow on screen instructions (sudo wget https://raw.githubusercontent.com/bitcrusherr/Lukso-Validator-Monitoring/main/setup.sh && sudo sh setup.sh) Without brackets

2 - You will need to edit Promethue.yml and add to the scrape configs (Check promethues.yml here for the data to input into your .yml file)

3 - Import the dashboard.json to grafana

4 - Start all services / applications and check to see if its all working (if not see trouble shooting below)

starting of services / applications at this stage is manual as they havent been setup as system services

# Trouble Shooting
If you are missing information or its not displayed correctly chances are the service isnt started or
there is a problem with the configuration, which could either be the prometheus.yml or even the information
promethues is able to grab.

You can check the query information and see the data grafana is pulling from prometheus and than check promethues to 
see if the data is coming up correclty there.

You may also find there are system metrics which come from different areas and require different queries,
this is done by just searching promethues for the one that suits your system.

If you are running on a vm / vps chances are some system metrics will not be available for example tempretures
