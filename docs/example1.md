# Installing PAS with Default Settings on ASDK

## Desired State

this will install a basic version of  PCF SRT with the following default Parameters:

- Resoource Group PCF
- Network 10.0.0.0 ( /16 used)
- SubDomain PCFDemo
- location local
- domain azurestack.external
- latest opsman 2.3 (2.3-build 244)


## Command to run

```Powershell
 .\pcf\deploy_pcf-opsman.ps1 -downloadpath E:\PCF\ -PAS_AUTOPILOT
```

![image](https://user-images.githubusercontent.com/8255007/52518133-3df04480-2c46-11e9-8f7c-0b27453a90fb.png)


Expecte Deployment Time:

