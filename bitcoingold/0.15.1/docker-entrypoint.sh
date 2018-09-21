#!/bin/bash
set -e

if [[ "$1" == "bgold-cli" || "$1" == "bitcoin-tx" || "$1" == "bgoldd" || "$1" == "test_bitcoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/bitcoingold.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoingold.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoingold
	chown -h bitcoin:bitcoin /home/bitcoin/.bitcoingold

	exec gosu bitcoin "$@"
else
	exec "$@"
fi