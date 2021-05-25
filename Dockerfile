FROM cirrusci/flutter:stable

RUN flutter config --enable-linux-desktop
RUN apt-get update && apt-get install -y --no-install-recommends clang cmake ninja-build pkg-config libgtk-3-dev libblkid-dev liblzma-dev
