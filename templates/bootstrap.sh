#!/bin/bash

set -xe

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:wireguard/wireguard -y
sudo apt-get install wireguard -y

sudo mkdir -p /etc/wireguard
cat >/tmp/wg0.conf <<CONFEND
[Interface]
Address = ${bastion_ip}
ListenPort = ${bastion_port}
PrivateKey = ${bastion_private_key}

[Peer]
PublicKey = ${client_public_key}
AllowedIPs = ${client_ip}
CONFEND

sudo mv /tmp/wg0.conf /etc/wireguard
sudo chmod 0600 /etc/wireguard/wg0.conf

sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0.service
