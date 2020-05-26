#!/bin/bash

${BESU_CONFIG_DIRECTORY:=/config/}
${BESU_KEYS_DIRECTORY:=/opt/besu/keys/}
${BESU_PUBLIC_KEY_DIRECTORY:=/opt/besu/public-keys/}

${HOST:=127.0.0.1}
${PORT_P2P:=30303}
${PORT_HTTP:=8545}
${PORT_WS:=8546}
${PORT_GRAPHQL:=8547}
${PORT_METRICS:=9545}

[ ! -z ${BESU_CONFIG_TOML_BASE64} ] && echo "${BESU_CONFIG_TOML_BASE64}" | base64 -d > ${BESU_CONFIG_DIRECTORY}/config.toml
[ ! -z ${BESU_CONFIG_GENESIS_BASE64} ] && echo "${BESU_CONFIG_GENESIS_BASE64}" | base64 -d > ${BESU_CONFIG_DIRECTORY}/genesis.json
[ ! -z ${BESU_PRIVATE_KEY_BASE64} ] && echo "${BESU_PRIVATE_KEY_BASE64}" | base64 -d > ${BESU_KEYS_DIRECTORY}/key
[ ! -z ${BESU_PUBLIC_KEY_BASE64} ] && echo "${BESU_PUBLIC_KEY_BASE64}" | base64 -d > ${BESU_KEYS_DIRECTORY}/key.pub
[ ! -z ${BESU_BOOTNODE_PUBLIC_KEY_BASE64} ] && echo "${BESU_BOOTNODE_PUBLIC_KEY_BASE64}" | base64 -d > ${BESU_PUBLIC_KEY_DIRECTORY}/bootnode_pubkey

${BOOTNODES_ARG:=--bootnodes}

if [[ ! -z "${BESU_BOOTNODE_P2P_ADDRESS}" ]]; then
  # Start Besu as validator / rpc node
  bootnode_pubkey=`sed 's/^0x//' ${BESU_PUBLIC_KEY_DIRECTORY}/bootnode_pubkey`
  bootnode_enode_address="enode://${bootnode_pubkey}@${BESU_BOOTNODE_P2P_ADDRESS}"
  BOOTNODES_ARG=--bootnodes=${bootnode_enode_address}
fi

/opt/besu/bin/besu \
  $@ \
  ${BOOTNODES_ARG} \
  --config-file=${BESU_CONFIG_DIRECTORY}/config.toml \
  --genesis-file=${BESU_CONFIG_DIRECTORY}/genesis.json \
  --node-private-key-file=${BESU_KEYS_DIRECTORY}/key \
  --p2p-host=${HOST} \
  --p2p-port=${PORT_P2P} \
  --rpc-ws-port=${PORT_WS} \
  --rpc-http-port=${PORT_HTTP} \
  --graphql-http-port=${PORT_GRAPHQL} \
  --metrics-port=${PORT_METRICS}