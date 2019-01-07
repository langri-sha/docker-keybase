FROM ubuntu
LABEL maintainer "Filip Dupanović (https://keybase.io/langrisha)"

ARG DEBIAN_FRONTEND=noninteractive
ARG CURLOPTS="--remote-time --location --fail --tlsv1.2 --show-error"

RUN apt-get update \
	&& apt-get install -y apt-utils \
	&& apt-get dist-upgrade -y

RUN apt-get install -y \
		curl \
		gnupg \
	&& apt-get install -y --no-install-recommends \
		fuse \
		libappindicator1 \
		libgconf-2-4 \
		psmisc

	# Get and verify Keybase.io's code signing key
RUN curl $CURLOPTS --silent https://keybase.io/docs/server_security/code_signing_key.asc | \
		gpg --import \
	&& gpg --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7 \

	# Get, verify and install client package
	&& curl $CURLOPTS --silent -O https://prerelease.keybase.io/keybase_amd64.deb.sig \
	&& curl $CURLOPTS -O https://prerelease.keybase.io/keybase_amd64.deb \
	&& gpg --verify keybase_amd64.deb.sig keybase_amd64.deb \
	&& dpkg -i keybase_amd64.deb

	# Create group, user
RUN groupadd -g 1000 keybase \
	&& useradd --create-home -g keybase -u 1000 keybase

	# Cleanup
RUN rm -r /var/lib/apt/lists/* \
	&& rm keybase_amd64.deb*

USER keybase
WORKDIR /home/keybase
CMD ["bash"]

RUN run_keybase
