#!/bin/bash
set -u
set -e

function usage() {
  echo ""
  echo "Usage:"
  echo "    $0 [tessera | tessera-remote | constellation] [--tesseraOptions \"options for Tessera start script\"]"
  echo ""
  echo "Where:"
  echo "    tessera | tessera-remote | constellation (default = tessera): specifies which privacy implementation to use"
  echo "    --tesseraOptions: allows additional options as documented in tessera-start.sh usage which is shown below:"
  echo ""
  ./tessera-start.sh --help
  exit -1
}

privacyImpl=tessera
tesseraOptions=
while (( "$#" )); do
    case "$1" in
        tessera)
            privacyImpl=tessera
            shift
            ;;
        constellation)
            privacyImpl=constellation
            shift
            ;;
        tessera-remote)
            privacyImpl="tessera-remote"
            shift
            ;;
        --tesseraOptions)
            tesseraOptions=$2
            shift 2
            ;;
        --help)
            shift
            usage
            ;;
        *)
            echo "Error: Unsupported command line parameter $1"
            usage
            ;;
    esac
done

NETWORK_ID=$(cat genesis.json | tr -d '\r' | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

if [ $NETWORK_ID -eq 1 ]
then
	echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
    echo "  please set the chainId in the genensis.json to another value "
	echo "  1337 is the recommend ChainId for Geth private clients."
fi

if [ "$privacyImpl" == "tessera" ]; then
  echo "[*] Starting Tessera nodes"
  ./tessera-start.sh ${tesseraOptions}
elif [ "$privacyImpl" == "constellation" ]; then
  echo "[*] Starting Constellation nodes"
  ./constellation-start.sh
elif [ "$privacyImpl" == "tessera-remote" ]; then
  echo "[*] Starting tessera nodes"
  ./tessera-start-remote.sh ${tesseraOptions}
else
  echo "Unsupported privacy implementation: ${privacyImpl}"
  usage
fi

echo "[*] Starting Ethereum nodes with ChainID and NetworkId of $NETWORK_ID"
QUORUM_GETH_ARGS=${QUORUM_GETH_ARGS:-}
set -v
ARGS="--nodiscover --verbosity 5 --networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --ws --wsaddr 0.0.0.0 --wsapi db,eth,net,web3,personal,txpool,admin --emitcheckpoints $QUORUM_GETH_ARGS"
PRIVATE_CONFIG=data/tm.ipc nohup geth --datadir data $ARGS --permissioned --raftport 7117 --rpcport 8200 --port 8107 --wsport 8201 --wsorigins "*" --unlock 0 --password passwords.txt 2>>data/logs/geth.log &
set +v

echo
echo "Node configured. See 'data/logs' for logs, and run e.g. 'geth attach data/geth.ipc' to attach to the Geth node."
echo "To test sending a private transaction from Node to other Node, run './runscript.sh private-contract.js'"

exit 0