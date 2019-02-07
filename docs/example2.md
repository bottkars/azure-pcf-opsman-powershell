# Installing PAS, Azure Service Proker and Spring Cloud Services


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
named director_<subdomain>.json 

```
Powershell
.\scripts\pcf_login.ps1 -DIRECTOR_CONF_FILE $HOME/director_pcftesting.json
```

![image](https://user-images.githubusercontent.com/8255007/52395724-7c073000-2aaf-11e9-9635-5bb327ee9c8e.png)

### Creating an example tile for AzureStack Dashboard

the script create_dashboardtiles.ps1 creates an output to build a customized Dashboard for you PCF Installation in AzureStack.

1. run the script

```
.\scripts\create_dashboardtiles.ps1 -DIRECTOR_CONF_FILE $HOME\director_pcftesting.json
```

2. mark and copy the outpt the output

3. In the Azure Portal, click on New Dashboard
![image](https://user-images.githubusercontent.com/8255007/52396575-b1614d00-2ab2-11e9-9360-37f66a496cfe.png)

4. Place a New Markdown Tile on The Dashboard
![image](https://user-images.githubusercontent.com/8255007/52396724-1c128880-2ab3-11e9-964e-ea85571a7803.png)

5. Paste the script output to the Markdown Edit Pane and give it a Titel and Description


<img src="https://user-images.githubusercontent.com/8255007/52396920-ce4a5000-2ab3-11e9-8e1b-e234b370da8e.png" width="50">



6. Finally give The Dashboard a Name and click done Customizing

![image](https://user-images.githubusercontent.com/8255007/52396992-18cbcc80-2ab4-11e9-8823-8dec92d318ba.png)


You can now click on the *Opsman Green* link to access the PCF Operations Manager ( default opsman/Password123!)

to access the Pivotal Aplications Manager, Click on the *Pivotal Application Service* link on the Dashboard

The Application Service Dashboard will open.   
But we need Credentials.  
the user name is admin and the credentials are ...   

yes, we can use the same script thatb we used to connect to the api service, with -show_creds

```Powershell
.\scripts\pcf_login.ps1 -DIRECTOR_CONF_FILE $HOME/director_pcftesting.json -showcreds
```

![image](https://user-images.githubusercontent.com/8255007/52397193-e1115480-2ab4-11e9-9c21-85d34ef3b557.png)

Copy and Paste the credtials to sign in :smile:

![image](https://user-images.githubusercontent.com/8255007/52397322-4f561700-2ab5-11e9-8bb7-67664cc3c67a.png)



