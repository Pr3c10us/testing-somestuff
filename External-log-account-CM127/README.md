# Monitored Account

### NOTE 
* The Account ID of the monitored account should have been added to the to the log_destination.tf file of the Destination account
* The Destination account should have been deployed before deploying the Monitored Account(s)
* The Account ID of the Destination Account should be added as a variable in the subscription.tf file 

### Procedure
* git clone git clone https://github.com/Abdul-bakri/Central-Logging-in-Multi-Account.git
* cd Central-Logging-in-Multi-Account
* cd External-log-account-CM127
* terraform init
* terraform plan 
* terraform apply
