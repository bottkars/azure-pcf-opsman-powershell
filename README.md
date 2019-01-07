# PCF Azure Resource Manager (ARM) Templates and PAS AUTOPILOT

This repo contains ARM templates that help operators deploy Ops Manager Director for Pivotal Cloud Foundry (PCF). 

It also feature a Powershell Script to automate beyond what the template can do:
    - Configure required Storage Accounts 
    - Download the Pivotal Operation Manager Image
    - Configure Pivotal Operation Manager
    - Auto Deploy Deploy PCF and add on Tiles
The Powershell scipt makes use of:
    - [omcli](https://github.com/pivotal-cf/om)  
    - [PIVPOSH](https://github.com/bottkars/PIVPosh) 
    - openssl for certificate creation



## requirements
    - Windows 10 or Server 2016 Machine with at least 20GB Disk Space (SSD recommended) 
    - Pre Configured  Certificates OR openssl ( can be installed with prepare_utils.ps1)
    - omcli and PIVPOS ( can be installed with prepare_utils.ps1)

## usage
 



## Deploying Opsman only

A Detailed Walkthrough can be found here  
[Part1 Deploy Ops Manager](https://community.emc.com/blogs/azurestack_guy/2018/06/22/getting-started-with-pcf-on-azurestack-asdk-part-1-deploy-opsmanager)  
[Part2 Configure Ops Manager Bosh Director](https://community.emc.com/blogs/azurestack_guy/2018/08/01/getting-started-with-pcf-on-azurestack-asdk-part-2-configure-opsmanager)  

[srt](./pas_srt_worksheet.md)  

