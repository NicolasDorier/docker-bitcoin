FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOINGOLD_VERSION 0.15.1
ENV BITCOINGOLD_URL https://github.com/BTCGPU/BTCGPU/releases/download/v0.15.1/bitcoin-gold-0.15.1-x86_64-linux-gnu.tar.gz
ENV BITCOINGOLD_SHA256 06d65c01a275d9324ed96078b8aa68c992c23bf1e815be25ef0c6c948be760de
ENV BITCOINGOLD_ASC_URL https://github.com/BTCGPU/BTCGPU/releases/download/v0.15.1/SHA256SUMS.asc
ENV BITCOINGOLD_PGP_KEY 0x38EE12EB597B4FC0

# install bitcoingold binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO bitcoingold.tar.gz "$BITCOINGOLD_URL" \
	&& echo "$BITCOINGOLD_SHA256 bitcoingold.tar.gz" | sha256sum -c - \
	&& gpg --keyserver keyserver.ubuntu.com --recv-keys "$BITCOINGOLD_PGP_KEY" \
	&& wget -qO bitcoingold.asc "$BITCOINGOLD_ASC_URL" \
	&& gpg --verify bitcoingold.asc \
	&& tar -xzvf bitcoingold.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoingold \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoingold
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8337 8338 18337 18338 18443 18444
CMD ["bgoldd"]