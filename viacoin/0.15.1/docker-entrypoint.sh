#!/bin/bash
set -e

if [[ "$1" == "viacoin-cli" || "$1" == "viacoin-tx" || "$1" == "viacoind" || "$1" == "test_viacoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/viacoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/viacoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.viacoin
	chown -h bitcoin:bitcoin /home/bitcoin/.viacoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi