# Installing PAS, Azure Service Broker and Spring Cloud Services


## Desired State

This is the Goal State

![image](https://user-images.githubusercontent.com/8255007/52395430-680efe80-2aae-11e9-9049-9460d3d07144.png)

## Tiles we want to Install

- PAS
- Microsoft Azure Service Broker
- Mysql
- RabbitMQ
- Spring Cloud Services

## Requirements

The Azure Service Broker needs and Azure Service Pricipal with Access to a Subscription with Contributer rights. It will be used to

    - Create the SQL Conig Server and Database
    - A Resource Group 
    - Act as the Provisioner for Service Broker

Therefore, we need a env.json also including the AZURE Resources

```Json
{
"client_id": "redacted",
"client_secret": "redacted",
"PCF_PIVNET_UAA_TOKEN": "redacted",
"NTP_SERVERS_STRING": "192.168.1.1",
"OM_Password": "Password123!",
"OM_Username": "opsman",
"SMTP_ADDRESS": "",
"SMTP_IDENTITY": "",
"SMTP_PASSWORD": "",
"SMTP_FROM": "",
"SMTP_PORT": "",
"PCF_NOTIFICATIONS_EMAIL": "user@example.com",
"AZURE_CLIENT_ID": "redacted",
"AZURE_CLIENT_SECRET": "redacted",
"AZURE_REGION": "westeurope",
"AZURE_SUBSCRIPTION_ID": "redacted",
"AZURE_TENANT_ID": "redacted",
"AZURE_DATABASE_ENCRYPTION_KEY": "redacted"
}
```

## Deployment Call

```Powershell
.\deploy_pcf-opsman.ps1 -resourceGroup pcftesting `
-location local -dnsdomain azurestack.external `
-PCF_SUBDOMAIN_NAME pcftesting `
-subnet 10.90.0.0 `
-tiles spring, masb `
-downloadpath E:\PCF
```

The Installation will install PCF in pcftesting.local.azurestack.external.  
The Opsman will be pcfopsmangreen.pcftesting.local.azurestack.external.  
All Sources will be Downloaded to / Uploaded from E:\PCF


![image](https://user-images.githubusercontent.com/8255007/52395405-4b72c680-2aae-11e9-95bf-746164082c26.png)


## Connect After the Installation


### coneccting to cf cli 
a helper script is awialable that
- queries om for the admin credentials
- connect to the cf api target
the script utilizes a DIRECTOR_CONF_FILE that is created by the installer  in you homedirectory
named director_<resourcegroup>.json 

```
Powershell
.\scripts\pcf_login.ps1 -DIRECTOR_CONF_FILE $HOME/director_pcftesting.json
```

![image](https://user-images.githubusercontent.com/8255007/52395724-7c073000-2aaf-11e9-9635-5bb327ee9c8e.png)



to create the Custom Dashboard, see [Dashboard](/dashboard.md)