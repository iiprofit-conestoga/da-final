# Database CI/CD Pipeline Documentation

## Overview
This document describes the Continuous Integration/Continuous Deployment (CI/CD) pipeline for the Database Automation project. The pipeline automates the deployment and testing of database schema changes and data operations.

## Pipeline Structure

### 1. Trigger Conditions
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```
- The pipeline runs when:
  - Code is pushed to the `main` branch
  - A pull request is made to the `main` branch

### 2. Environment Setup
```yaml
jobs:
  database-deployment:
    runs-on: ubuntu-latest
```
- Runs on the latest Ubuntu environment
- Provides a clean, isolated environment for each run

### 3. Code Checkout
```yaml
    - uses: actions/checkout@v2
```
- Gets the latest code from your repository
- Makes all files available to the workflow

### 4. Python Setup
```yaml
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.x'

    - name: Install Python dependencies
      run: |
        python -m pip install --upgrade pip
        pip install mysql-connector-python
```
- Sets up Python environment
- Installs required Python packages (mysql-connector-python)

### 5. Database Cleanup
```yaml
    - name: Cleanup Database
      run: |
        mysql -h ${{ secrets.DB_HOST }} -u ${{ secrets.DB_USER }} -p${{ secrets.MYSQL_ROOT_PASSWORD }} < sql/00_cleanup.sql
```
- Runs `00_cleanup.sql`
- Drops existing database
- Creates fresh database
- Ensures clean state for testing

### 6. Initial Schema Creation
```yaml
    - name: Execute Initial Schema
      run: |
        mysql -h ${{ secrets.DB_HOST }} -u ${{ secrets.DB_USER }} -p${{ secrets.MYSQL_ROOT_PASSWORD }} < sql/01_initial_schema.sql
```
- Runs `01_initial_schema.sql`
- Creates the `ClimateData` table with initial columns:
  - record_id
  - location
  - record_date
  - temperature
  - precipitation

### 7. Schema Update
```yaml
    - name: Execute Schema Update
      run: |
        mysql -h ${{ secrets.DB_HOST }} -u ${{ secrets.DB_USER }} -p${{ secrets.MYSQL_ROOT_PASSWORD }} < sql/02_schema_update.sql
```
- Runs `02_schema_update.sql`
- Adds the `humidity` column to the table

### 8. Sample Data Seeding
```yaml
    - name: Seed Sample Data
      run: |
        mysql -h ${{ secrets.DB_HOST }} -u ${{ secrets.DB_USER }} -p${{ secrets.MYSQL_ROOT_PASSWORD }} < sql/03_sample_data.sql
```
- Runs `03_sample_data.sql`
- Inserts sample climate data for various cities
- Tests data insertion functionality

### 9. Concurrent Query Testing
```yaml
    - name: Run Concurrent Queries
      env:
        DB_HOST: ${{ secrets.DB_HOST }}
        DB_USER: ${{ secrets.DB_USER }}
        DB_PASSWORD: ${{ secrets.MYSQL_ROOT_PASSWORD }}
        DB_NAME: ${{ secrets.DB_NAME }}
      run: |
        python scripts/multi_thread_queries.py
```
- Runs the Python script for concurrent operations
- Tests:
  - Multiple simultaneous inserts
  - Concurrent selects
  - Parallel updates
- Verifies database performance under load

### 10. Deployment Validation
```yaml
    - name: Validate Deployment
      run: |
        mysql -h ${{ secrets.DB_HOST }} -u ${{ secrets.DB_USER }} -p${{ secrets.MYSQL_ROOT_PASSWORD }} -e "
          USE ${{ secrets.DB_NAME }};
          SELECT COUNT(*) FROM ClimateData;
          DESCRIBE ClimateData;
        "
```
- Final verification step
- Checks:
  - Total number of records
  - Table structure
  - Ensures all columns are present
  - Verifies data integrity

## Security Features
- Uses GitHub Secrets for sensitive data:
  - `MYSQL_ROOT_PASSWORD`
  - `DB_HOST`
  - `DB_USER`
  - `DB_NAME`
- Credentials are never exposed in logs
- Secure connection to remote database

## Error Handling
- Each step runs independently
- If any step fails, the workflow stops
- Provides clear error messages
- Ensures database consistency

## Required GitHub Secrets
To run the pipeline, the following secrets must be set in your GitHub repository:
1. `MYSQL_ROOT_PASSWORD`: Database root password
2. `DB_HOST`: Remote database host address
3. `DB_USER`: Database username
4. `DB_NAME`: Database name

## How to Set Up Secrets
1. Go to your GitHub repository
2. Click on "Settings"
3. Click on "Secrets and variables" → "Actions"
4. Click "New repository secret"
5. Add each secret with its corresponding value

## Monitoring the Pipeline
1. Go to your GitHub repository
2. Click on the "Actions" tab
3. Select the workflow run you want to monitor
4. Click on each job to see detailed logs

## Troubleshooting
- If the pipeline fails:
  1. Check the error message in the Actions tab
  2. Verify all secrets are correctly set
  3. Ensure the remote database is accessible
  4. Check if the SQL scripts are properly formatted 