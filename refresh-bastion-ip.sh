#!/bin/bash

set -e

INST_NAME="wireguard-bastion"
PUBLIC_KEY="BASTION_PUBLIC_KEY"
PUBLIC_PORT=51999

PRIVATE_IP=10.200.63.40

PUBLIC_IP=$(aws ec2 describe-instances \
    --region eu-central-1 \
    --filter "Name=instance-state-name,Values=running" \
    --filter "Name=tag:Name,Values=$INST_NAME" \
    --query 'Reservations[*].Instances[*].NetworkInterfaces[*].Association.PublicIp' \
    --output text)

if [[ "$PUBLIC_IP" == "" ]]; then
    echo "Bastion is not running"
    exit 1
fi

sudo wg set wg0 \
    peer $PUBLIC_KEY \
    allowed-ips $PRIVATE_IP \
    endpoint $PUBLIC_IP:$PUBLIC_PORT
