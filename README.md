# docker-keybase

[![Image][image-badge]][image] [![Workspace][workspace-badge]][workspace]

A Docker image with the [Keybase](https://keybase.io) client, installed from
Keybase's signed package.

## Usage

Build the image, start a named container, then log in and provision the device:

```sh
docker build --tag langrisha/keybase .
docker run --name keybase -it langrisha/keybase
```

Detach with <kbd>Ctrl</kbd>+<kbd>P</kbd> <kbd>Ctrl</kbd>+<kbd>Q</kbd>, and use
Keybase from the host:

```sh
echo "secret" | docker exec -i keybase keybase encrypt max
```

Reattach with `docker attach keybase`.

## Keeping your device

Copy your user and device configuration out of the container:

```sh
docker cp keybase:/home/keybase/.config/keybase config
```

Then build it into an image of your own:

```dockerfile
FROM langrisha/keybase

USER root
COPY ./config/* .config/keybase/
RUN chown -R keybase:keybase .config/keybase
USER keybase
```

The container runs `bash` as the user `keybase`, with UID and GID 1000.

[image]:
  https://github.com/langri-sha/docker-keybase/actions/workflows/image.yml
[image-badge]:
  https://github.com/langri-sha/docker-keybase/actions/workflows/image.yml/badge.svg
[workspace]:
  https://github.com/langri-sha/docker-keybase/actions/workflows/workspace.yml
[workspace-badge]:
  https://github.com/langri-sha/docker-keybase/actions/workflows/workspace.yml/badge.svg
