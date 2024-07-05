# docker_hass

[![build status](https://img.shields.io/github/actions/workflow/status/padhi-homelab/docker_hass/docker-release.yml?label=BUILD&branch=main&logo=github&logoWidth=24&style=flat-square)](https://github.com/padhi-homelab/docker_hass/actions?query=workflow%3A%22Docker+CI+Release%22)
[![testing size](https://img.shields.io/docker/image-size/padhihomelab/hass/testing?label=SIZE%20%5Btesting%5D&logo=docker&logoColor=skyblue&logoWidth=24&style=flat-square)](https://hub.docker.com/r/padhihomelab/hass/tags)
[![latest size](https://img.shields.io/docker/image-size/padhihomelab/hass/latest?label=SIZE%20%5Blatest%5D&logo=docker&logoColor=skyblue&logoWidth=24&style=flat-square)](https://hub.docker.com/r/padhihomelab/hass/tags)
  
[![latest version](https://img.shields.io/docker/v/padhihomelab/hass/latest?label=LATEST&logo=linux-containers&logoWidth=20&labelColor=darkmagenta&color=gold&style=for-the-badge)](https://hub.docker.com/r/padhihomelab/hass/tags)
[![image pulls](https://img.shields.io/docker/pulls/padhihomelab/hass?label=PULLS&logo=data:image/svg%2bxml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCAzMiAzMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8ZyBmaWxsPSIjZmZmIj4KICAgIDxwYXRoIGQ9Ik0yMC41ODcsMTQuNjEzLDE4LDE3LjI0NlY5Ljk4QTEuOTc5LDEuOTc5LDAsMCwwLDE2LjAyLDhoLS4wNEExLjk3OSwxLjk3OSwwLDAsMCwxNCw5Ljk4djYuOTYzbC0uMjYtLjA0Mi0yLjI0OC0yLjIyN2EyLjA5MSwyLjA5MSwwLDAsMC0yLjY1Ny0uMjkzQTEuOTczLDEuOTczLDAsMCwwLDguNTgsMTcuNGw2LjA3NCw2LjAxNmEyLjAxNywyLjAxNywwLDAsMCwyLjgzMywwbDUuOTM0LTZhMS45NywxLjk3LDAsMCwwLDAtMi44MDZBMi4wMTYsMi4wMTYsMCwwLDAsMjAuNTg3LDE0LjYxM1oiLz4KICAgIDxwYXRoIGQ9Ik0xNiwwQTE2LDE2LDAsMSwwLDMyLDE2LDE2LDE2LDAsMCwwLDE2LDBabTAsMjhBMTIsMTIsMCwxLDEsMjgsMTYsMTIuMDEzLDEyLjAxMywwLDAsMSwxNiwyOFoiLz4KICA8L2c+Cjwvc3ZnPgo=&logoWidth=20&labelColor=teal&color=gold&style=for-the-badge)](https://hub.docker.com/r/padhihomelab/hass)

---

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
