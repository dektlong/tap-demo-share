
# Configure your TAP demo 

This repo contains artifacts to setup TAP components and developer namespace, ready to deploy workloadss

## Prerequisites
- Please read https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-prerequisites.html
- Install Tanzu CLI https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-install-general.html#mac-tanzu-cli
- Kubectl access to a running k8s cluster
- User/Password to Tanzu network, or relocate all of TAP install images to a private repo
- Private repo access
- Update your information in the ```tap-values.yaml`` file 

## Deploy
- ```./dekt-tap-installer.sh init``` 
- The script will pause after installing core TAP and ask you to allocate a wildcard subdomain for your developer’s applications 
  - Make sure it matched the ```MY_INGRESS_DOMAIN``` value you specified in the ```cnrs.domain_name`` and ```tap_gui``` keys of the tap-values.yml                     

## Cleanup
- ```./dekt-tap-installer.sh cleanup```                        

# Enjoy!
