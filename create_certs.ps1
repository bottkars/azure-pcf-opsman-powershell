
"
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=DE
ST=Hessen
L=Taunusstein
O=Karsten Bott
OU=DEMO
CN = ${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = *.sys.pcfdemo.local.azurestack.external
DNS.2 = *.login.sys.pcfdemo.local.azurestack.external
DNS.3 = *.uaa.sys.pcfdemo.local.azurestack.external
DNS.4 = *.apps.pcfdemo.local.azurestack.external
" | set-content ./pcfdemo.local.azurestack.external.cnf 

C:\OpenSSL-Win64\bin\openssl.exe req -x509 `
  -newkey rsa:2048 `
  -nodes `
  -keyout ./pcfdemo.local.azurestack.external.key `
  -out ./pcfdemo.local.azurestack.external.cert `
  -config ./pcfdemo.local.azurestack.external.cnf 