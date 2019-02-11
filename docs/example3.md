# Editors Choice
my mots common  used Deployment has the following Tiles:  

- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_pivotalapplicationservice@2x.png" height="16"> Pivotal Application Service 2.3.6 
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_pivotal_mysql@2x.png" height="16"> MySQL 2.4.3
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_rabbitmq_cf@2x.png" height="16"> RabbitMQ 1.15.3
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_spring_cloud_services_cf@2x.png" height="16"> Spring Cloud Services 2.0.5
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/metrics-icon.png" height="16"> Pivotal Cloud Foundry Metrics ( APM ) 1.5.1
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_healthwatch@2x.png" height="16"> Pivotal Cloud Foundry Healthwatch 1.4.4
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_microsoft_azure_open_service_broker@2x.png" height="16"> Microsoft Azure Service Broker ( MASB )   

Depneding on your Configuration, this takes 6 to 8 hours to deploy:

## Desired State
 
![image](https://user-images.githubusercontent.com/8255007/52547299-05c43f80-2dc7-11e9-8f2c-06bfaa9a1351.png)

## Starting Deployment

```Powershell
.\deploy_pcf-opsman.ps1 `
-tiles spring,masb,apm,healthwatch
```

## Deployment Time 


from Powershell output  

![image](https://user-images.githubusercontent.com/8255007/52547505-8d5e7e00-2dc8-11e9-8ced-ac10c22db9d2.png)

changelog view  
![image](https://user-images.githubusercontent.com/8255007/52547290-f7762380-2dc6-11e9-8990-1fc0433586c5.png)


## login to PAS after installation 

```Powershell
.\scripts\pcf_login.ps1 -DIRECTOR_CONF_FILE $HOME\director_pcf.json
```

![image](https://user-images.githubusercontent.com/8255007/52547701-a9aeea80-2dc9-11e9-89fb-f028361b1a21.png)



to create the Custom Dashboard,
run 

```Powershell
.\scripts\create_dashboardtiles.ps1 -DIRECTOR_CONF_FILE $HOME\director_pcf.json
```
 see [Dashboard](/docs/dashboard.md) for Details