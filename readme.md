# AWS Wireguard Bastion

This is an example of how to deploy a bastion host to AWS and
connect to it using Wireguard VPN.

## Local setup

- setup Wireguard, on Ubuntu it is:

```
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:wireguard/wireguard -y
sudo apt-get install wireguard -y
```

- generate two pairs of keys: one for the basion host, one for the local machine

```
wg genkey >basion_private
wg genkey >client_private
wg pubkey <basion_private >basion_public
wg pubkey <client_private >client_public
```

- everywhere is source codes of this repo replace:
  - CLIENT_PRIVATE_KEY with conent of client_private
  - CLIENT_PUBLIC_KEY with conent of client_public
  - BASTION_PRIVATE_KEY with conent of bastion_private
  - BASTION_PUBLIC_KEY with conent of bastion_public

```
sed -i "s@CLIENT_PRIVATE_KEY@$(cat ./client_private)@g" wg0.conf.local
sed -i "s@CLIENT_PUBLIC_KEY@$(cat ./client_public)@g"   variables.tf
sed -i "s@BASTION_PRIVATE_KEY@$(cat ./basion_private)@g" variables.tf
sed -i "s@BASTION_PUBLIC_KEY@$(cat ./basion_public)@g" refresh-bastion-ip.sh
```

- start and enable Wireguard locally

```
sudo cp wg0.conf.local /etc/wireguard/wg0.conf
sudo chmod 0600 /etc/wireguard/wg0.conf
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0.service
```

## AWS Bastion Setup

- deploy the infrastructure using Terraform

## Test connectivity

```
./refresh-bastion-ip.sh
ping 10.200.63.40
```

## License

MIT-0

## Help & Services

My name is Gennady.  I'm an experienced DevOps engineer.
If you need help, drop me a line at [gtrafimenkov+services@fastmail.com](mailto:gtrafimenkov+services@fastmail.com).
