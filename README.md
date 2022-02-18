
# Configure your TAP demo 

This repo contains artifacts to setup TAP components and developer namespace, ready to deploy workloadss

## Prerequisites
- Please read https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-prerequisites.html
- Kubectl access to a running k8s cluster
- Ingress domain configured
- User/Password to Tanzu network, or relocate all of TAP install images to a private repo
- Private repo access
- Update your information in the ```tap-values.yaml`` file 

## Deploy
- ```./dekt-tap-installer.sh init```                        

## Cleanup
- ```./dekt-tap-installer.sh cleanup```                        

# Enjoy!
