desktop-runtime:
	cd desktop-runtime \
	&& DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t kmaehashi/xojo-desktop-runtime:ubuntu20.04 .
.PHONY: desktop-runtime

xojo:
	cd xojo \
	&& DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 -f Dockerfile.2022r11 -t kmaehashi/xojo-docker:xojo2022r11-ubuntu20.04 .
.PHONY: xojo
