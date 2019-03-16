param(
    [Parameter(Mandatory = $true)]	
    [string]$user,
    [Parameter(Mandatory = $false)]
    [ValidateSet('add','delete')]
    $assignment = 'add'	,
    [Parameter(Mandatory = $true)]
    [ValidateSet('system','healthwatch')]
    [alias('app')]$space
)
<#
.$PSScriptRoot/uaa_login.ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE
$users = uaac curl -k /Users  | Select-String "RESPONSE BODY:" -Context 0, 10000000
$Userlist = ($USERS -replace "RESPONSE BODY:" -replace ">" |  ConvertFrom-Json).resources

$Wavefront_user = ($Userlist | where-object userName -match wavefront-nozzle)
#>
$assignment = $assignment.tolower()
switch ($space)
{
    'healthwatch'
{
$roles = ('healthwatch.read','healthwatch.admin')
}
    'system'
{
$roles = ('cloud_controller.admin','uaa.admin','scim.read','scim.write')
}
}
foreach ($role in $roles) {
    Write-Host -ForegroundColor White -NoNewline "running member $assignment  $role for  $user ==> "
    uaac member $assignment $role $user
}


