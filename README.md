# bitcoin-testing-tools

This repository aims to build a bitcoin test framework based on signet.
Docker is extensively used to provide:
* a bitcoin node that mines bitcoin on a custom signet
* a bitcoin node that downloads the custom signet chain (can be used to test bitcoin layer-2 software)
* a core-lightning node

### Preparation

First of all, you have o make sure that port 60602 is reachable from all over the internet. 

On ubuntu you can install `ufw` with
```
sudo apt install -y ufw
```
Then you need to set some default configuration and enable the firewall:
```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging off
sudo ufw enable
```

After that, you need to allow connection on the 60602 port for make electrum server reachable from all over the internet:
```
sudo ufw allow 60602/tcp comment 'allow Electrum Signet SSL'
```

### Usage

The system is thought to have a stand-alone machine on which the bitcoin miner node and core-clightning node run

```
docker-compose -f docker-compose_miner_signet.yml up
``` 

and other machines on which a bitcoin node and a core-lightning node run

```
docker-compose -f docker-compose_node_signet.yml up
```

*NOTE*
The bitcoin node must be fund before operate. A faucet is in development and will be integrated in the workflow.