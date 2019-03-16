param(
[Parameter(Mandatory = $true)]
$PCF_SUBDOMAIN_NAME,
[Parameter(Mandatory = $true)]
$PCF_DOMAIN_NAME,
[Parameter(Mandatory = $true)]
$OM_TARGET
)
$DOMAIN="$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME)"
$KEY_BITS=2048
$DAYS=365
"
[ req ]
prompt = no
distinguished_name = dn
[ dn ]
C  = DE
O = labbuildr
CN = labbuildr autogenerated CA
" | set-content "$HOME/certconfig.conf"

C:\OpenSSL-Win64\bin\openssl req -new -x509 -nodes -sha256 `
-newkey rsa:$KEY_BITS -days $DAYS `
-keyout "$($HOME)/$($DOMAIN).ca.key.pkcs8" `
-out "$($HOME)/$($DOMAIN).ca.crt" -config "$($HOME)/certconfig.conf"


C:\OpenSSL-Win64\bin\openssl rsa `
 -in "$($HOME)/$($DOMAIN).ca.key.pkcs8"`
 -out "$($HOME)/$($DOMAIN).ca.key"

"
  [ req ]
  prompt = no
  distinguished_name = dn
  req_extensions = v3_req
  [ dn ]
  C  = DE
  O = labbuildr
  CN = *.$($DOMAIN)
  [ v3_req ]
  subjectAltName = DNS:*.$($DOMAIN), DNS:*.apps.$($DOMAIN), DNS:*.sys.$($DOMAIN), DNS:*.login.sys.$($DOMAIN), DNS:*.uaa.sys.$($DOMAIN), DNS:*.pks.$($DOMAIN)
" | set-content  "$HOME/config.csr"

C:\OpenSSL-Win64\bin\openssl req `
  -nodes -sha256 -newkey rsa:$KEY_BITS -days $DAYS `
  -keyout "$($HOME)/$($DOMAIN).key" -out "$($HOME)/$($DOMAIN).csr" -config "$HOME/config.csr"

"
  basicConstraints = CA:FALSE
  subjectAltName = DNS:*.$($DOMAIN), DNS:*.apps.$($DOMAIN), DNS:*.sys.$($DOMAIN), DNS:*.login.sys.$($DOMAIN), DNS:*.uaa.sys.$($DOMAIN), DNS:*.pks.$($DOMAIN)
  subjectKeyIdentifier = hash
" | set-content "$HOME/extfile.txt"

C:\OpenSSL-Win64\bin\openssl x509 -req -in "$($HOME)/$($DOMAIN).csr" `
-CA "$($HOME)/$($DOMAIN).ca.crt" `
-CAkey "$($HOME)/$($DOMAIN).ca.key.pkcs8" `
-CAcreateserial -out "$($HOME)/$($DOMAIN).host.crt" -days $DAYS -sha256 -extfile $extfile "$($HOME)/extfile.txt"


## and now we go for OM_TARGET
if ($OM_TARGET -match "green")
{
 $OM_TARGET_GREEN= $OM_TARGET
 $OM_TARGET_BLUE=$OM_TARGET -replace "green","blue"
}
else {
    $OM_TARGET_BLUE= $OM_TARGET
    $OM_TARGET_GREEN=$OM_TARGET -replace "blue","green"
}
foreach ($TARGET in ($OM_TARGET_GREEN,$OM_TARGET_BLUE))
{  
 
"
  [ req ]
  prompt = no
  distinguished_name = dn
  req_extensions = v3_req
  [ dn ]
  C  = DE
  O = labbuildr
  CN = $($TARGET)
  [ v3_req ]
  subjectAltName = DNS:$($TARGET)
" | set-content  "$HOME/config.csr"
Write-Host "Creating KEY for $TARGET" 

C:\OpenSSL-Win64\bin\openssl req `
  -nodes -sha256 -newkey rsa:$KEY_BITS -days $DAYS `
  -keyout "$($HOME)/$($TARGET).key" -out "$($HOME)/$($TARGET).csr" -config "$HOME/config.csr"

"
  basicConstraints = CA:FALSE
  subjectAltName = DNS:$($TARGET)
  subjectKeyIdentifier = hash
" | set-content "$HOME/extfile.txt"

Write-Host "Creating Cert for $TARGET" 

C:\OpenSSL-Win64\bin\openssl x509 -req `
-in "$($HOME)/$($TARGET).csr" `
-CA "$($HOME)/$($DOMAIN).ca.crt" `
-CAkey "$($HOME)/$($DOMAIN).ca.key.pkcs8" `
-CAcreateserial -out "$($HOME)/$($TARGET).crt" -days $DAYS -sha256 -extfile $extfile "$($HOME)/extfile.txt"

}
$content = Get-Content "$($HOME)/$($DOMAIN).host.crt"
$content += Get-Content "$($HOME)/$($DOMAIN).ca.crt"
$content | Set-Content "$($HOME)/$($DOMAIN).crt"

