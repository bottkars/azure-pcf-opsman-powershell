param(
$PCF_SUBDOMAIN_NAME = "pcfdemo",
$PCF_DOMAIN_NAME = "local.azurestack.external"
)

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
CN = $PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = *.sys.$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME
DNS.2 = *.login.$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME
DNS.3 = *.uaa.sys.$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME
DNS.4 = *.apps.$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME
" | set-content "$HOME/$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME.cnf"

C:\OpenSSL-Win64\bin\openssl.exe req -x509 `
  -newkey rsa:2048 `
  -nodes `
  -keyout "$HOME/$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME.key" `
  -out "$HOME/$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME.cert" `
  -config "$HOME/$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME.cnf"