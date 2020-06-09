ARG BESU_VERSION=1.4.5

FROM isslab/exflo-besu:$BESU_VERSION

COPY docker_entrypoint.sh /
COPY config/config.toml /config/
COPY config/genesis.json /config/
COPY config/keys/key /opt/besu/keys/
COPY config/keys/key.pub /opt/besu/keys/
COPY config/keys/bootnode_pubkey /opt/besu/public-keys/

ENTRYPOINT ["/docker_entrypoint.sh"]