#!/bin/bash

# Create directory for SignOz data
mkdir -p ~/signoz/data

# Create OpenTelemetry collector configuration
cat > ~/signoz/data/otel-collector-config.yaml << 'EOF'
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 1s
    send_batch_size: 1024

exporters:
  clickhouse:
    endpoint: tcp://clickhouse:9000
    database: signoz_traces
    username: default
    password: signoz
    timeout: 5s
    sending_queue:
      queue_size: 100
    retry_on_failure:
      enabled: true
      initial_interval: 5s
      max_interval: 30s
      max_elapsed_time: 300s

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [clickhouse]
EOF

echo "OpenTelemetry collector configuration created at ~/signoz/data/otel-collector-config.yaml" 