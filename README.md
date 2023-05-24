# Lukso-Validator-Monitoring
Monitor your lukso validator using a few apps put togethor and a modified eth dashboard!

setup.sh can install but not fully configure the following:
Grafana
Prometheus
Node-Exporter
JSON-Exporter
Blackbox_Exporter

1 - Run setup.sh follow instructions

2 - You will need to edit Promethue.yml and add to the scrape configs (Check promethues.yml for the data)

3 - Import the Dashboard.json

4 - Start all services and check to see if its all working


# Trouble Shooting
If you are missing information or its not displayed correctly chances are the service isnt started or
there is a problem with the confiuration, which could either be the prometheus.yml or even the information
promethues is able to grab.

You can check the query informatioin and see the queries its sending to promethues and check promethues to 
see if the data is coming up.

You may also find there are system metrics which come from different areas and require different queries,
this is done by just searching promethues for the one that suits your system.
