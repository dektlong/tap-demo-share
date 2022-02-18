
# Configure your TAP demo 

This repo contains artifacts to setup TAP components and developer namespace, ready to deploy workloads

## Prerequisites
- Please read https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-prerequisites.html
- Install Tanzu CLI https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-install-general.html#mac-tanzu-cli
- Kubectl access to a running k8s cluster
- User/Password to Tanzu network, or relocate all of TAP install images to a private repo
- Private repo access
- Update your information in the ```tap-values.yaml``` file 

## Setup
- ```./dekt-tap-installer.sh init``` 
  - Note: The script will pause after installing core TAP and ask you to allocate a wildcard subdomain for your developer’s applications 
  
## Start

```
  tanzu apps workload create tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --namespace my-apps
    --yes
```
- read more https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-getting-started.html

## Cleanup
- ```./dekt-tap-installer.sh cleanup```                        

# Enjoy!
