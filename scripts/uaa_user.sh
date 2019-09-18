USER_NAME=pcfuser@labbuildr.com
USER_NAME=mmvay@pivots.labbuildr.com
USER_NAME=kbott@pivotal.io
cf create-user $USER_NAME labbuildr_AAD


uaac member add cloud_controller.admin ${USER_NAME}
uaac member add uaa.admin ${USER_NAME}     
uaac member add scim.read ${USER_NAME}     
uaac member add scim.write ${USER_NAME}     