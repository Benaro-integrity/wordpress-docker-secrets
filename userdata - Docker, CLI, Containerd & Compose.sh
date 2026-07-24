#!/bin/bash

# Update package index and install prerequisite packages
apt-get update
apt-get install -y ca-certificates curl

# Create directory for Docker's GPG key
install -m 0755 -d /etc/apt/keyrings

# Download and install Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding the repository
apt-get update

# Install Docker Engine, CLI, Containerd, and the Docker Compose plugin
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add the 'ubuntu' user to the docker group so you can run docker commands without sudo
usermod -aG docker ubuntu

# Enable the Docker service to start on boot
systemctl enable docker

# Start the Docker service
systemctl start docker