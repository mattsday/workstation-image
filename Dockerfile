FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Setup Firebase and Genkit
RUN npm install -g firebase-tools genkit

# Setup Terraform
RUN wget https://releases.hashicorp.com/terraform/1.9.6/terraform_1.9.6_linux_amd64.zip -O terraform.zip && unzip terraform.zip terraform && mv terraform /usr/local/bin/ && chmod +x /usr/local/bin/terraform && rm terraform.zip

# Install some useful packages
RUN apt-get update && apt-get install -y zsh shellcheck htop curl git unzip xz-utils zip

# Install Flutter & its dependencies
RUN apt-get install -y libglu1-mesa libc6:amd64 libstdc++6:amd64 libbz2-1.0:amd64 && wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz -O flutter.tar.xz && tar -xf flutter.tar.xz -C /opt && rm flutter.tar.xz

# Copy runtime config (extensions, shell scripts, etc)
COPY scripts/120_install_extensions.sh scripts/100_user_env.sh /etc/workstation-startup.d/
