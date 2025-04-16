#!/bin/bash

# Exit on error
set -e

echo "Setting up SignOz for MySQL monitoring..."

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Install Docker Compose if not already installed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create directory for SignOz
mkdir -p ~/signoz
cd ~/signoz

# Download SignOz Docker Compose file
echo "Downloading SignOz Docker Compose file..."
curl -s https://raw.githubusercontent.com/SigNoz/signoz/develop/deploy/docker/clickhouse-setup/docker-compose.yaml -o docker-compose.yaml

# Start SignOz
echo "Starting SignOz..."
docker-compose up -d

# Wait for SignOz to be ready
echo "Waiting for SignOz to be ready..."
sleep 30

# Apply MySQL configuration
echo "Applying MySQL configuration..."
docker cp ../monitoring/signoz_config.yaml signoz-query-service:/etc/signoz/config/
docker exec signoz-query-service /bin/bash -c "cd /etc/signoz && ./apply-config.sh"

# Enable MySQL logging
echo "Enabling MySQL logging..."
mysql -h $DB_HOST -u $DB_USER -p$MYSQL_ROOT_PASSWORD < ../monitoring/enable_mysql_logging.sql

echo "SignOz setup complete!"
echo "Access SignOz dashboard at: http://localhost:3301"
echo "Default credentials: admin / admin" 