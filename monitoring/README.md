# MySQL Monitoring with SignOz

This directory contains configuration files and scripts for setting up advanced monitoring and logging for the MySQL database using SignOz.

## Files

- `signoz_config.yaml`: Configuration file for SignOz monitoring
- `enable_mysql_logging.sql`: SQL script to enable MySQL slow query logging and performance schema
- `setup_signoz.sh`: Shell script to install and configure SignOz

## Prerequisites

- Docker Desktop installed and running
- MySQL client installed
- Access to the remote MySQL server

## Setup Instructions

1. Make the setup script executable:
   ```bash
   chmod +x monitoring/setup_signoz.sh
   ```

2. Ensure Docker Desktop is running on your Mac

3. Run the setup script:
   ```bash
   ./monitoring/setup_signoz.sh
   ```

4. Access the SignOz dashboard at http://localhost:3301
   - Default credentials: admin / admin

## Monitoring Features

### Log Collection
- MySQL error logs
- Slow query logs
- Connection failure logs

### Metrics Collection
- CPU usage
- DTU consumption
- Query performance
- Connection failures

### Alerts Configuration
- High CPU usage (> 80% for 5 minutes)
- High DTU consumption (> 70% for 5 minutes)
- Long-running queries (> 1 second)
- Connection failures (> 5 in 5 minutes)

## Dashboard Setup

The SignOz dashboard is configured to display the following panels:

1. **CPU Usage Panel**
   - Shows CPU usage percentage over time
   - Threshold line at 80%

2. **DTU Consumption Panel**
   - Shows DTU consumption percentage over time
   - Threshold line at 70%

3. **Query Performance Panel**
   - Shows average query execution time
   - Threshold line at 1 second

4. **Error Logs Panel**
   - Shows connection failures and query errors
   - Filtered by severity level

## Alert Configuration

Alerts are configured to trigger notifications for:

1. **High CPU Usage**
   - Condition: CPU usage > 80%
   - Duration: 5 minutes
   - Severity: Critical
   - Notification: Email

2. **High DTU Consumption**
   - Condition: DTU consumption > 70%
   - Duration: 5 minutes
   - Severity: Warning
   - Notification: Email

3. **Long-running Queries**
   - Condition: Query execution time > 1 second
   - Duration: 1 minute
   - Severity: Critical
   - Notification: Email

4. **Connection Failures**
   - Condition: More than 5 connection failures
   - Duration: 5 minutes
   - Severity: Critical
   - Notification: Email

## Screenshots

*Note: Screenshots of the SignOz dashboard, alert configurations, and sample alert notifications should be added here after setup.*

## Troubleshooting

If you encounter issues with the SignOz setup:

1. Ensure Docker Desktop is running
2. Check Docker logs:
   ```bash
   docker logs signoz-query-service
   ```
3. Verify MySQL connection details in `signoz_config.yaml`
4. Ensure MySQL slow query logging and performance schema are enabled
5. If you see "connection refused" errors, make sure the MySQL server is accessible from your machine 