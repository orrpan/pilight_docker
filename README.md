# pilight using docker
## platforms:
* linux/386
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
    hostname: pilight
    image: orrpan/pilight_docker:latest
    ports:
      - '5003:5003'
      - '5001:5001'
    environment:
      - TZ=Europe/Stockholm
    volumes:
      - 'home/`whoami`/.pilight/:/etc/pilight/'
    restart: unless-stopped
    privileged: true
    devices:
        - /dev/ttyUSB0:/dev/ttyUSB0
```