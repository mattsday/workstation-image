FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Setup Gemini, Firebase, and Genkit
RUN npm install -g firebase-tools genkit @google/gemini-cli@latest

# Setup Terraform
RUN wget https://releases.hashicorp.com/terraform/1.9.6/terraform_1.9.6_linux_amd64.zip -O terraform.zip && unzip terraform.zip terraform && mv terraform /usr/local/bin/ && chmod +x /usr/local/bin/terraform && rm terraform.zip

# Workaround: Remove Helm repo that's broken as of 2025-09-16
RUN rm /etc/apt/sources.list.d/helm-stable-debian.list

# Install some useful packages
RUN apt-get update && apt-get install -y zsh shellcheck htop curl git unzip xz-utils zip libxkbcommon0 libgtk-3-0t64 libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-gl libgtk-4-1 libgraphene-1.0-0 libxslt1.1 libvpx9 libevent-2.1-7 libflite1 libwebpdemux2 libwebpmux3 libavif16 libharfbuzz-icu0 libenchant-2-2 libsecret-1-0 libhyphen0 libmanette-0.2-0 libgles2 libx264-164 libgstreamer-plugins-bad1.0-0 libwoff1

# Install Flutter & its dependencies
RUN apt-get install -y libglu1-mesa libc6:amd64 libstdc++6:amd64 libbz2-1.0:amd64 && wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz -O flutter.tar.xz && tar -xf flutter.tar.xz -C /opt && rm flutter.tar.xz

# Install .NET and its dependencies
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && apt-get update && apt-get install -y dotnet-sdk-9.0

# Copy runtime config (extensions, shell scripts, etc)
COPY scripts/* /etc/workstation-startup.d/
