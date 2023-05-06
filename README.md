# bitcoin-testing-tools

This repository aims to build a bitcoin test framework based on signet.
Docker is extensively used to provide:
* a bitcoin node that mines bitcoin on a custom signet
* a bitcoin node that downloads the custom signet chain (can be used to test bitcoin layer-2 software)
* a core-lightning node

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