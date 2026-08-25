FROM buildpack-deps:bookworm-curl
LABEL maintainer="Filip Dupanović (https://keybase.io/langrisha)"

RUN \
	# Install dependencies
	apt-get update \
	&& apt-get install -y --no-install-recommends \
		fuse \
	# Get and verify Keybase.io's code signing key
	&& curl https://keybase.io/docs/server_security/code_signing_key.asc | \
		gpg --import \
	&& gpg --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7 \
	# Get, verify and install client package
	&& curl -O https://prerelease.keybase.io/keybase_amd64.deb.sig \
	&& curl -O https://prerelease.keybase.io/keybase_amd64.deb \
	&& gpg --verify keybase_amd64.deb.sig keybase_amd64.deb \
	&& apt-get install -y --no-install-recommends ./keybase_amd64.deb \
	# Create group, user
	&& groupadd -g 1000 keybase \
	&& useradd --create-home -g keybase -u 1000 keybase \
	# Cleanup
	&& rm -r /var/lib/apt/lists/* \
	&& rm keybase_amd64.deb*

USER keybase
WORKDIR /home/keybase
CMD ["bash"]

RUN run_keybase
