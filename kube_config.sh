#!/usr/bin/env bash

export KOPS_STATE_STORE=s3://clusters.sspcloudpro.co.in
API_SERVER="https://api.k8s.sspcloudpro.co.in"
TOKEN="XzqOlBkIdWrppXCmsj3baCqxOj3LLPcv"
CLUSTER_NAME="k8s.sspcloudpro.co.in"

kubectl config set preferences.colors true
kubectl config set-cluster ${CLUSTER_NAME} --server=${API_SERVER} --insecure-skip-tls-verify=true
kubectl config set-credentials ${CLUSTER_NAME} --token=${TOKEN}
kubectl config set-context k8s.sspcloudpro.co.in  --cluster=${CLUSTER_NAME} --user=${CLUSTER_NAME} --namespace=develop
# To test that configuration works
kubectl get pods --context="k8s.sspcloudpro.co.in" --namespace develop
kubectl config get-contexts --namespace develop
