FROM cirrusci/flutter:dev

RUN flutter config --enable-linux-desktop
RUN apt-get update && apt-get install clang cmake ninja-build pkg-config libgtk-3-dev libblkid-dev liblzma-dev
