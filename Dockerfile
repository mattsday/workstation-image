FROM ghcr.io/astral-sh/uv:latest AS uv-source
FROM oven/bun:latest AS bun-source
FROM amazon/aws-cli AS aws-cli
FROM mcr.microsoft.com/azure-cli AS azure-cli

FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:public-image-current

RUN echo Installing packages && \
    # Gemini, Genkit & Firebase tools
    npm install -g @google/gemini-cli firebase-tools genkit-cli --silent && \
    # hashicorp tools
    wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

# update and upgrade any system packages
RUN apt-get update && apt-get -y upgrade && \
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
        python3-venv \
        python-is-python3 \
        xz-utils \
        shellcheck \
        htop \
        packer \
        terraform \
        && apt-get remove --purge --auto-remove -y \
        && rm -rf /var/lib/apt/lists/*

COPY --from=uv-source /uv /usr/local/bin/uv
COPY --from=bun-source /usr/local/bin/bun /usr/local/bin/bun
COPY --from=aws-cli /usr/local/bin/aws /usr/local/bin/aws_completer /usr/local/bin/
COPY --from=azure-cli /usr/bin/az /usr/local/bin/az

# Copy runtime config (extensions, shell scripts, etc)
COPY --chmod=0755 scripts/*.sh /etc/workstation-startup.d/

