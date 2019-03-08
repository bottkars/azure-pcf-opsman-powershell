# PCF Azure Resource Manager (ARM) Templates and PAS AUTOPILOT
<img src="https://docs.pivotal.io/images/PVLG-PivotalApplicationService-Symbol.png" height="100"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Heart_coraz%C3%B3n.svg/800px-Heart_coraz%C3%B3n.svg.png" height="100">
<img src="./images/azurestack.png" height="100">



This repository contains ARM templates that help operators deploy Pivotal Cloud Foundry (PCF) to Azurestack (and azure) along with a number of Supported Services ( Tiles )


It features a set of Powershell Scripts to automate beyond what the template can do:  

- Configure required Storage Accounts  
- Download the Pivotal Operation Manager Image  
- Configure Pivotal Operation Manager  
- Auto Deploy Deploy PCF and add on Tiles
- Uses latest Stemcell by initially loading the latest
![deploy-pcf](https://user-images.githubusercontent.com/8255007/51845629-2b0d7400-2318-11e9-96dd-d4e3c3ff64b3.gif)   

The Powershell script makes use of:

- [omcli](https://github.com/pivotal-cf/om)  
- [PIVPOSH](https://github.com/bottkars/PIVPosh)  

the [certificate helper script](/create_certs.ps1) may require openssl: 

- openssl for certificate creation

*The user may also want to deploy my custom AzureStack Dashboard Tiles* :   

[Pivotal Cloud Foundry Dashboard Tile](/docs/tile1.md)  

[Additional Repo´s Tile](/docs/tile2.md)

those will create a dashboard view like this one:  
![image](https://user-images.githubusercontent.com/8255007/51927715-7dbc5e00-23f4-11e9-8664-ec5df43eb19e.png)  

### Initial supported Pivotal Cloudfoundry Tiles and Versions
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_pivotalapplicationservice@2x.png" height="16"> Pivotal Application Service 2.3.6 
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_pivotal_mysql@2x.png" height="16"> MySQL 2.4.3
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_rabbitmq_cf@2x.png" height="16"> RabbitMQ 1.15.3
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_spring_cloud_services_cf@2x.png" height="16"> Spring Cloud Services 2.0.5
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_scdf@2x.png" height="16"> Spring Cloud Dataflow 1.3.1
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_redis_cf@2x.png" height="16"> Redis 1.14.4
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/metrics-icon.png" height="16"> Pivotal Cloud Foundry Metrics ( APM ) 1.5.1
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_healthwatch@2x.png" height="16"> Pivotal Cloud Foundry Healthwatch 1.4.4
- <img src="https://dtb5pzswcit1e.cloudfront.net/assets/images/product_logos/icon_microsoft_azure_open_service_broker@2x.png" height="16"> Microsoft Azure Service Broker ( MASB )   
![image](https://user-images.githubusercontent.com/8255007/52365084-f9e32100-2a46-11e9-8281-81ce9456fa8c.png)   

### requirements

   - Windows 10 or Server 2016 Machine with at least 20GB Disk Space (SSD recommended) 
   - Pre Configured  Certificates OR openssl ( can be installed with prepare_utils.ps1)
   - Powershell 5
   - AzureStack / ASDK runnin 1811
   - omcli and PIVPOSH ( can be installed with prepare_utils.ps1)
   - a customized env.json file in the users $HOME, see [example](/env.example.json)
   - read the documentation, twice

#### certificates

when using PAS Autopilot, a SSL Certificate is required for the pcf subdomain, containing wildcars SAN´s for vwarious PCF subdomains. the Cerificate must have the name of the pcfsubdomain.azurestackdomain.crt  
if issued from a private / self signed Authority, the ca´s CERT must be appended to the file.  
for testing on AzureStack / ASDK, you can use the [certificate helper script](/create_certs.ps1) script.
To install OpenSSL, simply run the helper [utilities helper script](/prepare_utils.ps1), that will also install PivPosh

## Usage
this section desccribes various command options

### Basic testing / Opsman Director only

there is one central PS1 Script to deploy OPS Manager.  
just enter `deploy_pcf-opsman.ps1` will deploy the latest default OpsManager  

1. to get started, clone into the master branch. 
If you do not have git installed, i recommend

    ```Powershell
    install-script install-gitscm -scope currentuser
    install-gitscm.ps1
    ```
    then clone the Repo:

    ```Powershell
    git clone --single-branch --branch master https://github.com/bottkars/azure-pcf-opsman-powershell ./pcf
    set-location ./pcf
    ```

 *to update the repo, just `run git pull` at any time

2. Azure Stack CA root certificate for ASDK /Azure Stack
the azurestack root ca file must be located in $HOME/root.pem in pem format.
In case of ASDK, see [AzureStack Documentation](https://docs.microsoft.com/en-us/azure/azure-stack/azure-stack-cli-admin#export-the-azure-stack-ca-root-certificate) on how to obtain

On Integrated Systems, please put  the root Cert of the Enterprise PKI / Public Certifiaction Autority used to create the Azurestack Certificate into $HOME/root.pem

! DO NOT USE /var/lib/waagent/Certificates.pem, as this my contan WRONG DATA !

3. run the helper utility to install omcli, openssh and thge pivposh powershell module

```Powershell
./prepare_utils.ps1
```

4. start a deployment with a test parameter
    this wil make sure we can deploy to the desired resource group and test´s if we can use the storageaccount for opsman images ( note: the storageaccount for the images can be shared between different installations, for test , dev, etc. the deployment will create custom images from that location)

```
./deploy_pcf-opsman.ps1 -resourceGroup pcftest -location local -subnet 10.30.0.0 -PCF_SUBDOMAIN_NAME pcftest  -dnsdomain azurestack.external -downloadpath E:\PCF\ -TESTONLY
```

5. start the deployment
    once test and download´s are finished, run without test parameter. this is an example for an azure stack.  location ( region ) and dnsdomain of the Stack  might be omitted, the script will ask you for it anyway

```Powershell
./deploy_pcf-opsman.ps1 -resourceGroup pcftest -location local -subnet 10.30.0.0 -PCF_SUBDOMAIN_NAME pcftest  -dnsdomain azurestack.external -downloadpath E:\PCF\
```

if the installation  succeeds, be happy, everything is fine.  

6. Install the PAS Tile
to install the PAS Tile now, run

```Powershell
.\scripts\deploy_pas.ps1 -DIRECTOR_CONF_FILE $HOME\director_pcftest.json
```
**note**: *the file name is director_**rgname**.json* 

youn can use the deloyment_ scripts in the ./scripts folder to deploy all supported tiles manually after install. 

6. Delete the installation 

```Powershell
Get-AzureRmResourceGroup pcftest  | Remove-AzureRmResourceGroup -Force
```
this will remove the PCF installation. the pcfopsmanstorage ResourceGroup will remain, as you might want to re-use the images for the next installation  :sunglasses: 
## Advanced Installation Examples

### Example 1 Install PCF, Spring Dataflow and Spring Cloud Service
this will include required redis, rabbit and mysql

```Powershell
./deploy_pcf-opsman.ps1 -resourceGroup pcfprod `
 -subnet 10.30.0.0 `
 -PCF_SUBDOMAIN_NAME pcfprod `
 -downloadpath E:\PCF\ `
 -tiles spring,dataflow
``` 

### Example 2

see [example walkthrough](/docs/example2.md)

### product customizations  

the deployment tool uses product specific .json files that degtermine the Product version, and, in some cases ( e.g. srt or cf for pas) Product Names.  
If you want to use yoa specific product version, simply copy and customize the corresponding Json File from /examples to $HOME.   _DO NOT EDIT THE EXAMPLE FILES_ (as they are managed by git).  
 the shipped product files always contain the **latest and tested running on azurestack** ::verifyed_by_azurestack_guy::


#### Operations Manager Images

opsman images will be first downloaded locally and then uploaded to a *dedicated* storageaccount outside the PCF resource group. this allows for deleting the complete deployment without the reuirement to upload the OpsmanImage again

#### Tiles
procucts tile required will be downloaded to $HOME/downloads by default.    
to specify a different download directory, use  *-downloadpath yourpath*  when calling *deploy_pcf-opsman.ps1*.  
required products will be downloaded automatically using OMCLI when:
- *deploy_pcf-opsman.ps1* is stated with -force_procuct_download
- no productfile is available in the download location
##- More  Deployment EXAMPLES

below are some examples for running and customizing

### deploy PCF opsman and Pivotal Application Service (PAS SmallRunTime (SRT) )

```powershell
./deploy_pcf-opsman.ps1 -PAS_AUTOPILOT
```

### deploy PCF opsman and Pivotal Application Service and FULL CF

-PAS_TYPE allows you to switch from srt ( default) to full CF

```powershell
./deploy_pcf-opsman.ps1 -PAS_AUTOPILOT -PAS_TYPE cf
```

### Deploy PCF Opsman, SRT, MYSQL, RabbitMq and Spring Cloud Services

```Powershell
./deploy_pcf-opsman.ps1 `
 -resourceGroup pcfprod `
 -subnet 10.30.0.0 `
 -PCF_SUBDOMAIN_NAME pcfprod `
 -downloadpath E:\PCF\ `
 -tiles spring,dataflow
```

### Deploying Opsman only

A Detailed Walkthrough can be found here  
[Part1 Deploy Ops Manager](https://community.emc.com/blogs/azurestack_guy/2018/06/22/getting-started-with-pcf-on-azurestack-asdk-part-1-deploy-opsmanager)  
[Part2 Configure Ops Manager Bosh Director](https://community.emc.com/blogs/azurestack_guy/2018/08/01/getting-started-with-pcf-on-azurestack-asdk-part-2-configure-opsmanager)  



