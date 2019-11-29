echo "[*] Cleaning up temporary data directories"

rm -rf data/quorum-raft-state
rm -rf data/raft-snap
rm -rf data/raft-wal

echo "[*] Initialising geth genesis"
geth --datadir data removedb
geth --datadir data init genesis.json