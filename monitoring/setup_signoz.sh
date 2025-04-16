#!/bin/bash

# Exit on error
set -e

echo "Setting up SignOz for MySQL monitoring..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Create directory for SignOz
mkdir -p ~/signoz
cd ~/signoz

# Download SignOz Docker Compose file
echo "Downloading SignOz Docker Compose file..."
curl -s https://raw.githubusercontent.com/SigNoz/signoz/main/deploy/docker/clickhouse-setup/docker-compose.yaml -o docker-compose.yaml

# Start SignOz
echo "Starting SignOz..."
docker compose up -d

# Wait for SignOz to be ready
echo "Waiting for SignOz to be ready..."
sleep 30

# Create a directory for MySQL configuration
mkdir -p ~/signoz/config

# Copy the configuration file
cp ../monitoring/signoz_config.yaml ~/signoz/config/

# Apply MySQL configuration
echo "Applying MySQL configuration..."
docker exec signoz-query-service mkdir -p /etc/signoz/config
docker cp ~/signoz/config/signoz_config.yaml signoz-query-service:/etc/signoz/config/

# Enable MySQL logging
echo "Enabling MySQL logging..."
mysql -h $DB_HOST -u $DB_USER -p$MYSQL_ROOT_PASSWORD < ../monitoring/enable_mysql_logging.sql

echo "SignOz setup complete!"
echo "Access SignOz dashboard at: http://localhost:3301"
echo "Default credentials: admin / admin" 