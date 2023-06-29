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

#### Miner

The system is thought to have a stand-alone machine on which the bitcoin miner node and core-clightning node run

```
docker-compose -f docker-compose_miner_signet.yml up
``` 
From the "miner" can be useful to retrieve, the bitcoin core, the electrum server, and the faucet addresses with the following commands:
```
# Bitcoin Core Tor address
docker exec btc_sig_miner cli getnetworkinfo | jq -r ".localaddresses[].address"

# Bitcoin Signetchallenge
docker exec btc_sig_miner cat /bitcoind/bitcoin.conf | grep signetchallenge

# Electrum Server address
docker exec tor cat /var/lib/tor/hidden_service_electrs/hostname

# Bitcoin Faucet  address
docker exec tor cat /var/lib/tor/hidden_service_faucet/hostname
```
in order to replace the default parameters in the `make-node.sh` file and make available the custom blockchain and faucet to other "node" clients that whant to connect with the "miner".

#### Node

Other machines that whant to connect to the "miner", once the new parameters are set in the `make-node.sh` file, must run the `make-node.sh` file and then run the docker compose command:

```
docker-compose -f docker-compose_node_signet.yml up
```

#### Electrum wallet

Once the miner/non-miner node is running, electrum wallet can be used to perform normal operation. Electrum must be lauched with `-signet` flag and must be connected to the custom electrum server.

```
git clone https://github.com/spesmilo/electrum.git
cd electrum
python3 run_electrum --signet
```
At this point, create a new wallet and then go to `Tools --> Network`, de-select __Select server automatically__ flag and insert the onion address in the following format: `<electrum_server_onion_link>:60602`.
Now, you can get a new address from the Electrum wallet ad move some coin with 
```
docker exec btc_sig_miner bitcoin-cli -datadir=/bitcoind send '{"<new-address>": 1}'
```

#### Core-Lightning 
By running the `get-cln-strings.sh` make sure to run it after at least 100 blocks), strings to control the Core-Lightning node through [Zeus](https://github.com/ZeusLN/zeus) app and to share your node with other peers will be displayed.
