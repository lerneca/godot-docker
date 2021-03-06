FROM frolvlad/alpine-glibc:alpine-3.15_glibc-2.34

ENV GODOT_VERSION "3.4.4"

RUN apk update && apk add --no-cache ca-certificates unzip wget

RUN wget --quiet https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot \
    && rm -f Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip

RUN godot -e -q
