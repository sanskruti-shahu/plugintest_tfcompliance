# Use the latest Python Alpine image as the base
FROM python:alpine

# Install necessary dependencies
RUN apk --no-cache add \
    curl \
    unzip \
    git \
    gcc \
    musl-dev \
    bash

# Define Terraform version using an argument
ARG TERRAFORM_VERSION=1.1.0

# Download and install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    rm terraform.zip

# Install Terraform Compliance using pip
RUN pip install --no-cache-dir terraform-compliance

# Clean up unnecessary packages and cache
RUN apk del gcc musl-dev

# Set the working directory to /app
WORKDIR /app

# Set an environment variable for script options
ENV PLUGIN_ARGS=""

# Copy the script.sh file into /usr/local/bin/ and make it executable
COPY script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

# Set the entry point for the container to run script.sh
ENTRYPOINT ["/usr/local/bin/script.sh"]
