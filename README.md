# docker-besu

This repository contains scripts and configurations to build a flexible Docker image based on a given `hyperledger/besu` image. It allows for easy customization of most Besu config files and options via base64 encoding files into environment variables.

## Building the Image

Choose an available [hyperledger/besu tag](https://hub.docker.com/r/hyperledger/besu/tags), and supply it as a build arg to `docker build`.

```
# BESU_VERSION=1.4.4
# BESU_VERSION=1.4.5
BESU_VERSION=latest
docker build --build-arg BESU_VERSION=${BESU_VERSION} -t isslab/besu:${BESU_VERSION} .
```

## Running the Image

The following command starts a besu bootnode using the included [config/genesis.json](./config/genesis.json) and keys found in [config/keys/](./config/keys/). The ports used are defined by environment variable default vaules found in [docker_entrypoint.sh](./docker_entrypoint.sh).

```
docker run -d --name=besu-bootnode --network=host isslab/besu:${BESU_VERSION}
```

Find the `BESU_BOOTNODE_P2P_ADDRESS` in the logs:

```
docker logs besu-bootnode
...
Connect additional nodes using BESU_BOOTNODE_P2P_ADDRESS=127.0.0.1:30303
...
```

## Custom Configuration

This example starts a second node to connect to the previously started bootnode using custom keys and `config.toml`.

```
docker run -d --name=besu-validator --network=host \
  -e BESU_CONFIG_TOML_BASE64=$(cat config/config.toml | base64) \
  -e BESU_PRIVATE_KEY_BASE64=$(echo "47c63c0afd1a85b16915934a2d75cf5a0d3bd13c509d6ee9d7ef1315a36bdc0a" | base64) \
  -e BESU_PUBLIC_KEY_BASE64=$(echo "e40129f02c9e29a02049668346d4777bb55809042746882b33b20a8b5a7310eb5f107a53f0aa3da766ee77f401557a79c0c328329ea48bf0996c6c9dff817f76" | base64) \
  -e BESU_BOOTNODE_P2P_ADDRESS=127.0.0.1:30303 \
  -e PORT_P2P=30304 \
  -e PORT_HTTP=8555 \
  -e PORT_WS=8556 \
  -e PORT_GRAPHQL=8557 \
  -e PORT_METRICS=9555 \
  isslab/besu:${BESU_VERSION}
```