# Start with a lightweight base image
FROM debian:bullseye-slim

# Install dependencies and tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
ARG TERRAFORM_VERSION="v1.9.8"
RUN curl -sLo /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

# Install Terragrunt
ARG TERRAGRUNT_VERSION="0.68.4"
RUN curl -sLo /usr/local/bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
    && chmod +x /usr/local/bin/terragrunt

# Install jq
RUN curl -sLo /usr/local/bin/jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
    && chmod +x /usr/local/bin/jq

# Verify installations
RUN az version && terraform -version && terragrunt -version && jq --version

# Set default command
CMD ["bash"]
