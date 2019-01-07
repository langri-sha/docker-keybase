FROM ubuntu
LABEL maintainer "Filip Dupanović (https://keybase.io/langrisha)"

ARG DEBIAN_FRONTEND=noninteractive
ARG CURLOPTS="--remote-time --location --fail --tlsv1.2 --show-error"

ARG BUILD_DATE
ARG VCSREF

LABEL org.label-schema.name="keybase"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-url="https://github.com/langrisha/docker-keybase"
LABEL org.label-schema.vcs-ref="${VCSREF}"
LABEL org.label-schema.description="Docker container with signed Keybase.io client install"
LABEL org.label-schema.docker.cmd="docker run -ti --init --name keybase"
LABEL org.label-schema.build-date="${BUILD_DATE}"

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
RUN find /var/lib/apt -type f -delete \
	&& find /var/cache/apt -type f -delete \
	&& find /var/log -type f -regextype posix-extended -regex '.*\.(gz|xz|[0-9])' -delete \
	&& find /var/log -type f -exec truncate -s0 '{}' '+' \
	&& rm keybase_amd64.deb*

USER keybase
WORKDIR /home/keybase
CMD ["bash"]

RUN run_keybase
