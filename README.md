# PCF Azure Resource Manager (ARM) Templates and PAS AUTOPILOT

This repository contains ARM templates that help operators deploy Ops Manager Director for Pivotal Cloud Foundry (PCF) to Azurestack (and azure).  

It also feature a Powershell Script to automate beyond what the template can do:  

    - Configure required Storage Accounts  
    - Download the Pivotal Operation Manager Image  
    - Configure Pivotal Operation Manager  
    - Auto Deploy Deploy PCF and add on Tiles  

The Powershell script makes use of:

- [omcli](https://github.com/pivotal-cf/om)  
- [PIVPOSH](https://github.com/bottkars/PIVPosh)  

the [certificate helper script](/create_certs.ps1) may require openssl:
- openssl for certificate creation

*The user may also want to deploy my custom AzureStack Dashboard Tiles*

[Pivotal Cloud Foundry Dashboard Tile](/docs/tile1.md)   
[Additional Repo´s Tile](/docs/tile2.md)

### requirements

   - Windows 10 or Server 2016 Machine with at least 20GB Disk Space (SSD recommended) 
   - Pre Configured  Certificates OR openssl ( can be installed with prepare_utils.ps1)
   - Powershell 5
   - omcli and PIVPOSH ( can be installed with prepare_utils.ps1)
   - a customized env.json file in the users $HOME, see [example](/env.example.json)
#### certificates

when using PAS Autopilot, a SSL Certificate is required for the pcf subdomain, containing wildcars SAN´s for vwarious PCF subdomains. the Cerificate must have the name of the pcfsubdomain.azurestackdomain.crt  
if issued from a private / self signed Authority, the ca´s CERT must be appended to the file.  
for testing on AzureStack / ASDK, you can use the [certificate helper script](/create_certs.ps1) script.
To install OpenSSL, simply run the helper [utilities helper script](/prepare_utils.ps1), that will also install PivPosh
### usage

there is one central PS1 Script to deploy OPS Manager.  
just enter `deploy_pcf-opsman.ps1` will deploy the latest default OpsManager  

### product customizations  

the deployment tool uses product specific .json files that degtermine thge Product version, and, in some cases ( e.g. srt or cf for pas) Product Names.
If you want to use your own product version, simply copy and customize the corresponding Json File to $HOME. _DO NOT EDIT THE EXAMPLE FILES_ (as they are managed by git). the shipped product files always contain the **latest and tested running on azurestack**


#### Operation Manager Images

opsman images will be first downloaded locally and the uploaded do a *dedicated* storageaccount outside the PCF resource group. this allows for deleting the complete deployment without the reuirement to upload the OpsmanImage again

#### tiles
procucts tile required will be downloaded to $HOME/downloads.  
to specify a different download directory, use  *-downloadpath yourpath*  when calling *deploy_pcf-opsman.ps1*
required products will be downloaded automatically using OMCLI when:
    - *deploy_pcf-opsman.ps1* is stated with -force_procuct_download
    - no productfile is available in the download location
## EXAMPLES

below are some examples for running and customizing

### deploy PCF opsman and Pivotal Application Service (PAS SmallRunTime (SRT) )

```powershell
.\pcf\deploy_pcf-opsman.ps1 -PAS_AUTOPILOT
```

### deploy PCF opsman and Pivotal Application Service and FULL CF

-PAS_TYPE allows you to switch from srt ( default) to full CF

```powershell
.\pcf\deploy_pcf-opsman.ps1 -PAS_AUTOPILOT -PAS_TYPE cf
```

## Deploying Opsman only

A Detailed Walkthrough can be found here  
[Part1 Deploy Ops Manager](https://community.emc.com/blogs/azurestack_guy/2018/06/22/getting-started-with-pcf-on-azurestack-asdk-part-1-deploy-opsmanager)  
[Part2 Configure Ops Manager Bosh Director](https://community.emc.com/blogs/azurestack_guy/2018/08/01/getting-started-with-pcf-on-azurestack-asdk-part-2-configure-opsmanager)  



