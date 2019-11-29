#!/usr/bin/env bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf data
mkdir -p data/logs

echo "[*] Configuring node (permissioned)"
mkdir -p data/{keystore,geth}

#echo "[*] Initialising geth genesis"

#geth --datadir data init genesis.json

echo "[*] Initialising Tessera configuration"

currentDir=$(pwd)
DDIR="${currentDir}/data"
mkdir -p ${DDIR}
rm -f "${DDIR}/tm.ipc"

    #change tls to "strict" to enable it (don't forget to also change http -> https)
cat <<EOF > ${DDIR}/tessera-config.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:${DDIR}/db;MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
        "autoCreateTables": true
    },
    "serverConfigs":[
        {
            "app":"ThirdParty",
            "enabled": true,
            "serverAddress": "http://localhost:6181",
            "communicationType" : "REST"
        },
        {
            "app":"Q2T",
            "enabled": true,
             "serverAddress":"unix:${DDIR}/tm.ipc",
            "communicationType" : "REST"
        },
        {
            "app":"P2P",
            "enabled": true,
            "serverAddress":"http://localhost:6381",
            "sslConfig": {
                "tls": "OFF",
                "generateKeyStoreIfNotExisted": true,
                "serverKeyStore": "${DDIR}/server-keystore",
                "serverKeyStorePassword": "quorum",
                "serverTrustStore": "${DDIR}/server-truststore",
                "serverTrustStorePassword": "quorum",
                "serverTrustMode": "TOFU",
                "knownClientsFile": "${DDIR}/knownClients",
                "clientKeyStore": "${DDIR}/client-keystore",
                "clientKeyStorePassword": "quorum",
                "clientTrustStore": "${DDIR}/client-truststore",
                "clientTrustStorePassword": "quorum",
                "clientTrustMode": "TOFU",
                "knownServersFile": "${DDIR}/knownServers"
            },
            "communicationType" : "REST"
        }
    ],
    "peer": [],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "privateKeyPath": "${DDIR}/tm.key",
                "publicKeyPath": "${DDIR}/tm.pub"
            }
        ]
    },
    "alwaysSendTo": []
}
EOF

# Enclave configurations

cat <<EOF > ${DDIR}/tessera-config-enclave.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:${DDIR}/db;MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
        "autoCreateTables": true
    },
    "serverConfigs":[
        {
            "app":"ENCLAVE",
            "enabled": true,
            "serverAddress": "http://localhost:6281",
            "communicationType" : "REST"
        },
        {
            "app":"ThirdParty",
            "enabled": true,
            "serverAddress": "http://localhost:6181",
            "communicationType" : "REST"
        },
        {
            "app":"Q2T",
            "enabled": true,
             "serverAddress":"unix:${DDIR}/tm.ipc",
            "communicationType" : "REST"
        },
        {
            "app":"P2P",
            "enabled": true,
            "serverAddress":"http://localhost:6381",
            "sslConfig": {
                "tls": "OFF"
            },
            "communicationType" : "REST"
        }
    ],
    "peer": []
}
EOF

cat <<EOF > ${DDIR}/enclave.json
{
    "serverConfigs":[
        {
            "app":"ENCLAVE",
            "enabled": true,
            "serverAddress": "http://localhost:6281",
            "communicationType" : "REST"
        }
    ],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "privateKeyPath": "${DDIR}/tm.key",
                "publicKeyPath": "${DDIR}/tm.pub"
            }
        ]
    },
    "alwaysSendTo": []
}
EOF