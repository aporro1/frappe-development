FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3-dev \
    python3-pip \
    redis-server \
    postgresql-client \
    software-properties-common \
    xvfb \
    libfontconfig \
    wkhtmltopdf \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 14
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Install yarn
RUN npm install -g yarn

# Install bench
RUN pip3 install frappe-bench

# Create a non-root user
RUN useradd -m -s /bin/bash frappe
RUN echo "frappe ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER frappe
WORKDIR /home/frappe

# Initialize bench (will be done in entrypoint)
COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh

EXPOSE 8000-8005 9000-9005

ENTRYPOINT ["/entrypoint.sh"]