Xojo on Docker
==============

Docker image (based on Ubuntu 16.04) to run [Xojo](https://xojo.com) IDE and Desktop Apps.
The image is hosted on [Docker Hub](https://hub.docker.com/r/kmaehashi/xojo-docker).

Usage
-----

To run Xojo on host running Docker and connect via SSH X11 Forwarding:

```sh
ssh -Y host
```

Then run the container on the host:

```sh
docker run --rm --net host -v ~/.Xauthority:/root/.Xauthority -e DISPLAY kmaehashi/xojo-docker
```

Notes:
* SELinux may prevent accessing `.Xauthority` from inside Docker containers.
