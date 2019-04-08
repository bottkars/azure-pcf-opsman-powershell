## tbd

bosh alias-env asdk -e 10.0.8.11 --ca-cert /var/tempest/workspaces/default/root_ca_certificate

bosh update-config --name control_plane --type cloud control_plane.yml


platform_fault_domain_count