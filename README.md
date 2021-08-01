# pilight using docker, alpine linux 3.12

 
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/orrpan/pilight_docker/stable?style=for-the-badge) Stable/Latest

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/orrpan/pilight_docker/staging?style=for-the-badge) Staging

![Docker Pulls](https://img.shields.io/docker/pulls/orrpan/pilight_docker?style=for-the-badge)

## platforms:
* linux/amd64
* linux/arm/v6
* linux/arm/v7
* linux/arm64

## Run
`docker run --rm -it -p 5001:5001 orrpan/pilight_docker:latest`

## docker-compose
```yaml
version: '3.3'
services:
  pilight:
    container_name: pilight
    image: orrpan/pilight_docker:latest
    ports:
      - '5000-5003:5000-5003'
    environment:
      - TZ=Europe/Stockholm
    volumes:
      - '${HOME}/.pilight/:/etc/pilight/'
    restart: unless-stopped
    privileged: true
    #devices: # if you use usb
    # - /dev/ttyUSB0:/dev/ttyUSB0
    command:
      - /bin/sh
      - -c
      - |
        echo "sleep for 2sec"
        sleep 2
        /usr/local/sbin/pilight-daemon --foreground --config /etc/pilight/config.json

```
