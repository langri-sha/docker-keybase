TIMESTAMP := $(shell date -u "+%Y-%m-%dT%H:%M:%SZ")
VCSREF := $(shell git rev-parse --short HEAD)
ifneq ($(strip $(http_proxy)),)
	PROXY_ARG := --build-arg=http_proxy=$(strip $(http_proxy))
endif

all: build

build:
	@docker build -t keybase --build-arg=BUILD_DATE=$(TIMESTAMP) --build-arg=VCSREF=$(VCSREF) $(PROXY_ARG) .

