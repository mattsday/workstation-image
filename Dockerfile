FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

RUN echo Installing packages && \
    # Workaround for yarn bug in base image - TODO: Remove when fixed upstream
    # b/479803439
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo gpg --dearmour -o /usr/share/keyrings/yarn-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/yarn-keyring.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    # Gemini CLI & Firebase tools
    npm install -g @google/gemini-cli firebase-tools && \
    # install hashicorp tools
    wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt update && apt install packer terraform && \
    # Install the Pulumi SDK, including the cli and language runtimes.
    curl -fsSL https://get.pulumi.com/ | bash -s -- --version $PULUMI_VERSION && \
    mv ~/.pulumi/bin/* /usr/bin && \
    # update and upgrade any system packages
    apt-get update && apt -y upgrade && \
    # install packages
    apt-get install -y \
        btop \
        curl \
        wget \
        gnupg2 \
        software-properties-common \
        unzip \
        gnupg \
        direnv \
        jq \
        yq \
        yamllint \
        keychain \
        tcpdump \
        stow \
        zstd \
        zsh \
        python-is-python3 \
        xz-utils \
        shellcheck \
        htop \
        && apt-get remove --purge --auto-remove -y \
        && rm -rf /var/lib/apt/lists/* \
        && \
    # Install bun
    wget https://github.com/oven-sh/bun/releases/latest/download/bun-linux-x64.zip -O bun.zip && unzip bun.zip bun-linux-x64/bun && mv bun-linux-x64/bun /usr/local/bin/ && chmod +x /usr/local/bin/bun && rm bun.zip && rmdir bun-linux-x64

# Copy runtime config (extensions, shell scripts, etc)
COPY scripts/*.sh /etc/workstation-startup.d/

