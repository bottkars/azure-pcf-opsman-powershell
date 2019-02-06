
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_TARGET_GREEN = $director_conf.OM_TARGET
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain
$OM_TARGET_BLUE = "$($($OM_TARGET_GREEN -split ".")[0] -replace "green","blue").$PCF_SUBDOMAIN_NAME.$domain"



"
<a><img width='400' src='https://webassets.mongodb.com/_com_assets/cms/PivotalCloudFoundry-Logo-Vertical-OnLight-zi9nmbcbb5.png'/></a>
<br>
<a href='https://network.pivotal.io' target='_blank'>Pivotal Network </a>
<br>
<a href='https://docs.pivotal.io/pivotalcf/2-2/refarch/azure/azure_ref_arch.html#refarchs' target='_blank'>Pivotal Reference Architecture Azure</a>
<br>
<a href='http://pcfsizer.pivotal.io/#!/sizing/azure/2.2/small' target='_blank'>Pivotal PAS Sizer</a>
<br>
<a href='https://$OM_TARGET_GREEN'
target='_blank'>Opsman Green </a>
<br>
<a href='https://$OM_TARGET_BLUE' target='_blank'>Opsman Blue </a>
<br>
<a href='https://apps.sys.$PCF_SUBDOMAIN_NAME.$DOMAIN' target='_blank'>Pivotal Application Service</a>
<br>
<a href='http://vmjump-concourse.local.cloudapp.azurestack.external:8080' target='_blank'>Concourse CI</a>
<br>
<a href='https://dotnet-cookbook.cfapps.io/intro' target='_blank'>PCF .Net Cookbook</a>
<br>
<a href='https://ultimateguidetobosh.com/' target='_blank'>The Ultimate BoSH Guide</a>
" | Write-Output


Pop-Location