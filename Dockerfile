FROM frolvlad/alpine-glibc:alpine-3.15_glibc-2.34

ENV GODOT_VERSION "3.4.4"
ENV ANDROID_HOME="/usr/lib/android-sdk"

RUN apk update && apk add --no-cache ca-certificates unzip wget openjdk17 bash

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && rm -f Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && rm -f ~/.local/share/godot/templates/${GODOT_VERSION}.stable/linux* \
    && rm -f ~/.local/share/godot/templates/${GODOT_VERSION}.stable/android_source.zip \
    && rm -f ~/.local/share/godot/templates/${GODOT_VERSION}.stable/osx.zip \
    && rm -f ~/.local/share/godot/templates/${GODOT_VERSION}.stable/uwp* \
    && rm -f ~/.local/share/godot/templates/${GODOT_VERSION}.stable/webassembly* \
    && rm -f ~/.local/share/godot/templates/${GODOT_VERSION}.stable/windows*

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && unzip commandlinetools-linux-*_latest.zip -d cmdline-tools \
    && mv cmdline-tools $ANDROID_HOME/ \
    && rm -f commandlinetools-linux-*_latest.zip

ENV PATH="${ANDROID_HOME}/cmdline-tools/bin:${PATH}"

RUN yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses \
    && sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "build-tools;30.0.3" "platforms;android-29" "cmdline-tools;latest" "cmake;3.10.2.4988404" \
    && rm -fR $ANDROID_HOME/emulator

RUN godot -e -q
RUN echo 'export/android/android_sdk_path = "/usr/lib/android-sdk"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/debug_keystore = "/root/keys/debug.keystore"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/debug_keystore_user = "androiddebugkey"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/debug_keystore_pass = "android"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/force_system_user = false' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/timestamping_authority_url = ""' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/shutdown_adb_on_exit = true' >> ~/.config/godot/editor_settings-3.tres

RUN keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 \
    && mkdir -p /root/keys/ && mv debug.keystore /root/keys/debug.keystore