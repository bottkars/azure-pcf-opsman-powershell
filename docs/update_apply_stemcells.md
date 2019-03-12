# Automation for latest Stemcells



the stemcells running on the platform can be updated.
for that, run ./scripts/get-lateststemcells.ps1 to download and upload stemcells to BoSH Manager.

```Powershell
.\scripts\get-lateststemcells.ps1 -DIRECTOR_CONF_FILE $HOME/director_pcf.json
```
![get_latest_stemcell](/images/get_latest.png)

after stemcells are downloaded and inserted into OpsManager

```Powershell
.\scripts\apply_latest_stemcell.ps1 -DIRECTOR_CONF_FILE $HOME/director_pcf.json
```

![apply_latest_stemcell](/images/apply_latest_stem.png)