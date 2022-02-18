#!/usr/bin/env bash

#################### configs #######################

    PRIVATE_REPO=$(yq e .ootb_supply_chain_basic.registry.server tap-values.yaml)
    PRIVATE_REPO_USER=$(yq e .buildservice.kp_default_repository_username tap-values.yaml)
    PRIVATE_REPO_PASSWORD=$(yq e .buildservice.kp_default_repository_password tap-values.yaml)
    TANZU_NETWORK_USER=$(yq e .buildservice.tanzunet_username tap-values.yaml)
    TANZU_NETWORK_PASSWORD=$(yq e .buildservice.tanzunet_password tap-values.yaml)
        
    TAP_VERSION="1.0.0"

    DEV_NAMESPACE="my-apps"
  
#################### installers ################

    #install
    install() {

        install-tap-prereq

        tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION  --values-file tap-values.yaml -n tap-install

        setup-dev-ns

        echo
        echo "DNS SETUP"
        echo "1. Run: kubectl get svc envoy --namespace tanzu-system-ingress"
        echo "2. Create: A record mapping *.$(yq e .cnrs.domain_name tap-values.yaml) to the public IP output of phase 1"
        echo
        echo "Hit any key once complete..."
        read

        tanzu package installed update tap --package-name tap.tanzu.vmware.com --version $TAP_VERSION -n tap-install -f tap-values.yaml

    }

    #install-tap-prereq
    install-tap-prereq () {

        export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
        export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
        export INSTALL_REGISTRY_USERNAME=$TANZU_NETWORK_USER
        export INSTALL_REGISTRY_PASSWORD=$TANZU_NETWORK_PASSWORD
        pushd tanzu-cluster-essentials
        ./install.sh
        pushd

        kubectl create ns tap-install
        kubectl create ns $DEV_NAMESPACE
        
        tanzu secret registry add tap-registry \
            --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
            --server ${INSTALL_REGISTRY_HOSTNAME} \
            --export-to-all-namespaces --yes --namespace tap-install

        tanzu package repository add tanzu-tap-repository \
            --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION \
            --namespace tap-install
    }

    #setup-dev-ns
    setup-dev-ns () {
 
        tanzu secret registry add registry-credentials \
            --server $PRIVATE_REPO \
            --username $PRIVATE_REPO_USER \
            --password $PRIVATE_REPO_PASSWORD \
            --namespace $DEV_NAMESPACE
        
        kubectl apply -f supplychain-rbac.yaml -n $DEV_NAMESPACE

    }
    
    #deploy demo workloads
    deploy() {

        tanzu apps workload create -f workloads/devx-mood/mood-sensors.yaml -y
        tanzu apps workload create -f workloads/devx-mood/mood-portal.yaml -y
    }

    #cleanup
    cleanup() {

        tanzu package installed delete tap --namespace tap-install -y
        tanzu package repository delete tanzu-tap-repository --namespace tap-install -y
        kubectl delete ns tap-install
        kubectl delete ns $DEV_NAMESPACE

        
    }

    #incorrect usage
    incorrect-usage() {
        
        echo
        echo "Incorrect usage. Please specify one of the following: "
        echo
        echo "  init"
        echo
        echo "  cleanup"
        exit
    
    }

#################### main ##########################

case $1 in
init)
    install
    ;;
cleanup)
    cleanup
    ;;
*)
    incorrect-usage
    ;;
esac