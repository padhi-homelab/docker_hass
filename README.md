# docker_hass <a href='https://github.com/padhi-homelab/docker_hass/actions?query=workflow%3A%22Docker+CI+Release%22'><img align='right' src='https://img.shields.io/github/actions/workflow/status/padhi-homelab/docker_hass/docker-release.yml?branch=main&logo=github&logoWidth=24&style=flat-square'></img></a>

<a href='https://hub.docker.com/r/padhihomelab/hass'><img src='https://img.shields.io/docker/image-size/padhihomelab/hass/latest?label=size%20%5Blatest%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>
<a href='https://hub.docker.com/r/padhihomelab/hass'><img src='https://img.shields.io/docker/image-size/padhihomelab/hass/testing?label=size%20%5Btesting%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>

A **non-root** multiarch [HomeAssistant] Docker image with [HACS].

|        386         |       amd64        |       arm/v6       |       arm/v7       |       arm64        |         ppc64le          |          s390x           |
| :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------------: | :----------------------: |
| :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_multiplication_x: |

## Usage

### With Docker

```sh
docker run -p 8123:8123 \
           -e DOCKER_UID=`id -u` \
           -e DOCKER_GID=`id -g` \
           -v /path/to/store/config:/config \
           -it padhihomelab/hass
```

Runs HAss with WebUI served on port 8123.
<br>
To run it in background, use the `--detach` flag.

Usage with [Docker Compose] is similarly straightforward.
<br>
As an example, you can see my configuration in [services/hass].


[Docker Compose]: https://docs.docker.com/compose/
[HACS]:           https://hacs.xyz/
[HomeAssistant]:  https://www.home-assistant.io/
[services/hass]:  https://github.com/padhi-homelab/services/tree/master/hass
