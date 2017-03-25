# docker-keybase

[![Build Status][travis-ci-badge]][travis-ci]

Docker container with signed Keybase.io client install.

## Usage

Run a named container and attach to it.

```
docker run --name keybase -it langrisha/keybase
```

Login into your account and provision the device. You can now use keybase from within the container. Detach from the container to get back to your host.

```
ctrl+pq
```

Great, now you can execute commands from the host.

```
echo "secret" | docker exec -i keybase keybase encrypt max
```

And you can always attach to the container.

```
docker attach keybase
```

## Extend

You can extend the image and copy your user and device information.

```
# Dockerfile
FROM langrisha/keybase

USER root
COPY ./config/* .config/keybase/
RUN chown -R keybase:keybase .config/keybase
USER keybase
```

## Tips

You can copy your user and device information from a container to your host, or the other way around.

```
docker cp keybase:/home/keybase/.config/keybase config
```

## Notes

The container process is configured to run as the user `keybase` belonging to the `keybase` group (UID and GID `1000`). By default, runs the command `bash`.

Do not forget to run the container process interactively and to login with
your user when the container starts.

[travis-ci]: https://travis-ci.org/langri-sha/docker-keybase
[travis-ci-badge]: https://travis-ci.org/langri-sha/docker-keybase.svg?branch=master
