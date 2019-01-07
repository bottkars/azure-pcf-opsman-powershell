# PCF Azure Resource Manager (ARM) Templates and PAS AUTOPILOT

This repository contains ARM templates that help operators deploy Ops Manager Director for Pivotal Cloud Foundry (PCF) to Azurestack (and azure).  

It also feature a Powershell Script to automate beyond what the template can do:  

    - Configure required Storage Accounts  
    - Download the Pivotal Operation Manager Image  
    - Configure Pivotal Operation Manager  
    - Auto Deploy Deploy PCF and add on Tiles  

The Powershell script makes use of:

    - <[omcli](https://github.com/pivotal-cf/om)>    
    - [PIVPOSH](https://github.com/bottkars/PIVPosh)  
    - openssl for certificate creation

## requirements

    - Windows 10 or Server 2016 Machine with at least 20GB Disk Space (SSD recommended) 
    - Pre Configured  Certificates OR openssl ( can be installed with prepare_utils.ps1)
    - omcli and PIVPOSH ( can be installed with prepare_utils.ps1)
    - a customized env.json file in the users $HOME ( see example-env.json in examples)

## usage

there is one central PS1 Script to deploy OPS Manager.  
just enter deploy_pcf-opsman.ps1  

## product customizations  

the deployment tool uses product specifif .json files that degtermine thge Product version, and, in some cases ( e.g. srt or cf for pas) Product Names.
If you want to use your own product version, simply copy and customize the corresponding Json File to $HOME. _DO NOT EDIT THE EXAMPLE FILES_ (as they are managed by git)

## product download

procucts required will be townloaded to $HOME/downloads.  
to specify a different download directory, use  *-downloadpath yourpath*  when calling *deploy_pcf-opsman.ps1*
required products will be downloaded automatically using OMCLI when:
    - *deploy_pcf-opsman.ps1* is stated with -force_procuct_download


## Deploying Opsman only

A Detailed Walkthrough can be found here  
[Part1 Deploy Ops Manager](https://community.emc.com/blogs/azurestack_guy/2018/06/22/getting-started-with-pcf-on-azurestack-asdk-part-1-deploy-opsmanager)  
[Part2 Configure Ops Manager Bosh Director](https://community.emc.com/blogs/azurestack_guy/2018/08/01/getting-started-with-pcf-on-azurestack-asdk-part-2-configure-opsmanager)  

[srt](./pas_srt_worksheet.md)  

