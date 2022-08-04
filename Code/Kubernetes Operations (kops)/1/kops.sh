#!/bin/bash

# Kops Kubernetes HA deployment for aws
export CLOUD=aws
MASTER_NUMBER=3
MASTER_ZONES="eu-west-1a,eu-west-1b,eu-west-1c"
MASTER_SIZE="t2.medium"
WORKER_NUMBER=3
WORKER_ZONES="eu-west-1a,eu-west-1b,eu-west-1c"
WORKER_SIZE="t2.medium"
CNI_PLUGIN="calico" 
CLUSTER_NAME="testlab.k8s.local" # if ends in .k8s.local --> gossip-based cluster
K8S_VERSION=1.17.0
NETWORK_CIDR="10.240.0.0/16"
NW_TOPOLOGY="private" # public: uses a gateway | private
STORAGE_BUCKET=""
BUCKET_REGION="eu-west-1"
EXTRA_ARGS=" --target=terraform " 
# EXTRA_ARGS=" --target=cloudformation " 

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export KOPS_STATE_STORE="s3://${STORAGE_BUCKET}"

# configure cluster
kops create cluster --node-count ${WORKER_NUMBER} --zones ${WORKER_ZONES} \
    --master-zones ${MASTER_ZONES} --node-size ${WORKER_SIZE} \
    --master-size ${MASTER_SIZE} --kubernetes-version=${K8S_VERSION} \
    --network-cidr=${NETWORK_CIDR} --cloud=${CLOUD} \
    --topology ${NW_TOPOLOGY} --networking ${CNI_PLUGIN}   ${CLUSTER_NAME} \
    ${EXTRA_ARGS} \