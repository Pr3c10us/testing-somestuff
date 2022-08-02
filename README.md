# Central-Logging-in-Multi-Account

# central-logging-multi-account-environments
## Fuction
Centralized logging is often required in large enterprise environments for a number of reasons, ranging from compliance and security to analytics and application-specific needs.

I’ve seen that in a multi-account environment, whether the accounts belong to the same line of business or multiple business units, collecting logs in a central, dedicated logging account is an established best practice. It helps security teams detect malicious activities both in real-time and during incident response. It provides protection to log data in case it is accidentally or intentionally deleted. It also helps application teams correlate and analyze log data across multiple application tiers.


### Requirements  
* Minimum two AWS Accounts
  1) Destination Account(receives information from the monitored account(s))
  2) Monitored Account
* Python 3.7
* Terraform 
**[Install](https://learn.hashicorp.com/terraform/getting-started/install.html)**

### AWS Account 
* For more information about 
**[AWS Account](https://aws.amazon.com/account/)**

### NOTE 
* The identifier in the log_destination.tf should contain the account ID of the monitored account or accounts depending on the number of account you want to monitor 


### Procedure
* git clone git clone https://github.com/Abdul-bakri/Central-Logging-in-Multi-Account.git
* cd Central-Logging-in-Multi-Account
* terraform init
* terraform plan 
* terraform apply
This creates the Destination account.(To create the monitored account(s) read the readme in the External-log-account-CM127 folder) 
