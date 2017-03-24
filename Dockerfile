FROM buildpack-deps:jessie-curl
LABEL maintainer "Filip Dupanović (https://keybase.io/langrisha)"

RUN apt-get update && apt-get install -y \
		fuse \
		libappindicator1 \
		--no-install-recommends \
	&& rm -r /var/lib/apt/lists/* \
	&& curl https://keybase.io/docs/server_security/code_signing_key.asc | \
		gpg --import \
	&& gpg --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7 \
	&& curl -O https://prerelease.keybase.io/keybase_amd64.deb.sig \
	&& curl -O https://prerelease.keybase.io/keybase_amd64.deb \
	&& gpg --verify keybase_amd64.deb.sig keybase_amd64.deb \
	&& dpkg -i keybase_amd64.deb \
	&& apt-get install -f \
	&& groupadd -g 1000 keybase \
	&& useradd --create-home -g keybase -u 1000 keybase \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm keybase_amd64.deb*

USER keybase
WORKDIR /home/keybase
ENTRYPOINT ["keybase"]

RUN run_keybase
