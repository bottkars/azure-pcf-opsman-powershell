# Creating an example tile for AzureStack Dashboard

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


<img src="https://user-images.githubusercontent.com/8255007/52396920-ce4a5000-2ab3-11e9-8e1b-e234b370da8e.png" width="200">



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



