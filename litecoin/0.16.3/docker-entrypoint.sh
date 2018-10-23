#!/bin/bash
set -e

if [[ "$1" == "litecoin-cli" || "$1" == "litecoin-tx" || "$1" == "litecoind" || "$1" == "test_litecoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	if [[ ! -s "$BITCOIN_DATA/litecoin.conf" ]]; then
		cat <<-EOF > "$BITCOIN_DATA/litecoin.conf"
		printtoconsole=1
		rpcallowip=::/0
		${BITCOIN_EXTRA_ARGS}
		EOF
		chown bitcoin:bitcoin "$BITCOIN_DATA/litecoin.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.litecoin
	chown -h bitcoin:bitcoin /home/bitcoin/.litecoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
