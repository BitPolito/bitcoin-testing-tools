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

Once the miner/non-miner node is running, electrum wallet can be used to perform normal operation. Electrum must be lauched with `-signet` flag and must be connected to the custom electrum server.

```
git clone https://github.com/spesmilo/electrum.git
cd electrum
python3 run_electrum --signet
```
Get the electrum server onion address by lauching
```
docker exec tor cat /var/lib/tor/hidden_service_electrs/hostname
```
At this point, create a new wallet and then go to `Tools --> Network`, de-select __Select server automatically__ flag and insert the onion address in the following format: `<onion_link>:60602`.
Now, you can get a new address from the wallet ad move some coin with 
```
docker exec btc_sig_miner bitcoin-cli -datadir=/bitcoind send '{"<new-address>": 1}'
```

*NOTE*
The bitcoin node (non-miner node) must be fund before operate. A faucet is in development and will be integrated in the workflow.