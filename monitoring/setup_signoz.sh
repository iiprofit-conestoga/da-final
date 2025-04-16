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

# Create OpenTelemetry collector configuration
echo "Creating OpenTelemetry collector configuration..."
../monitoring/create_otel_config.sh

# Download SignOz Docker Compose file
echo "Downloading SignOz Docker Compose file..."
curl -s https://raw.githubusercontent.com/SigNoz/signoz/main/deploy/docker/clickhouse-setup/docker-compose.yaml -o docker-compose.yaml

# Check if the file was downloaded successfully
if [ ! -s docker-compose.yaml ]; then
    echo "Failed to download the Docker Compose file. Using a local copy instead."
    # Create a basic Docker Compose file for SignOz
    cat > docker-compose.yaml << 'EOF'
version: '3.7'

services:
  clickhouse:
    image: clickhouse/clickhouse-server:22.3.3.44-alpine
    container_name: clickhouse
    ports:
      - "8123:8123"
      - "9000:9000"
    volumes:
      - ./data/clickhouse-data:/var/lib/clickhouse
    ulimits:
      nofile:
        soft: 262144
        hard: 262144
    environment:
      - CLICKHOUSE_DB=signoz_traces
      - CLICKHOUSE_USER=default
      - CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1
      - CLICKHOUSE_PASSWORD=signoz
    command: ["--config-file=/etc/clickhouse-server/config.xml"]
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8123/ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  otel-collector:
    image: signoz/signoz-otel-collector:0.88.9
    container_name: otel-collector
    command: ["--config", "/etc/otel-collector/config.yaml"]
    volumes:
      - ./data/otel-collector-config.yaml:/etc/otel-collector/config.yaml
    ports:
      - "4317:4317"
      - "4318:4318"
      - "8888:8888"
      - "8889:8889"
    depends_on:
      - clickhouse

  query-service:
    image: signoz/query-service:0.88.9
    container_name: signoz-query-service
    ports:
      - "8080:8080"
      - "8081:8081"
    environment:
      - SIGNOZ_QUERY_SERVICE_URL=http://query-service:8080
      - SIGNOZ_OTEL_COLLECTOR_URL=http://otel-collector:4317
      - SIGNOZ_CLICKHOUSE_HOST=clickhouse
      - SIGNOZ_CLICKHOUSE_PORT=9000
      - SIGNOZ_CLICKHOUSE_USER=default
      - SIGNOZ_CLICKHOUSE_PASSWORD=signoz
      - SIGNOZ_CLICKHOUSE_DATABASE=signoz_traces
    depends_on:
      - clickhouse
      - otel-collector

  frontend:
    image: signoz/frontend:0.88.9
    container_name: signoz-frontend
    ports:
      - "3301:3301"
    environment:
      - SIGNOZ_API_URL=http://query-service:8080
    depends_on:
      - query-service
EOF
fi

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