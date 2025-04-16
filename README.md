# Database Automation Project

This project implements a CI/CD pipeline using GitHub Actions for automated deployment and schema changes for a MySQL database.

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci_cd_pipeline.yml
├── sql/
│   ├── 01_initial_schema.sql
│   ├── 02_schema_update.sql
│   └── 03_sample_data.sql
├── scripts/
│   └── multi_thread_queries.py
├── .gitignore
├── .secrets
└── README.md
```

## Database Schema

The project uses a MySQL database named `project_db` with a table `ClimateData` that stores climate-related data:

- record_id (INT, PRIMARY KEY, AUTO_INCREMENT)
- location (VARCHAR(100), NOT NULL)
- record_date (DATE, NOT NULL)
- temperature (FLOAT, NOT NULL)
- precipitation (FLOAT, NOT NULL)
- humidity (FLOAT, NOT NULL)

## Setup Instructions

1. Clone the repository
2. Create a `.secrets` file with your database credentials
3. Set up GitHub Secrets:
   - Add `MYSQL_ROOT_PASSWORD` to your repository secrets

## CI/CD Pipeline

The pipeline performs the following steps:
1. Sets up the MySQL service
2. Creates the initial database schema
3. Adds the humidity column
4. Seeds sample data
5. Runs concurrent queries
6. Validates the deployment

## Running Locally

1. Install dependencies:
   ```bash
   pip install mysql-connector-python
   ```

2. Set up your MySQL database:
   ```bash
   mysql -u root -p < sql/01_initial_schema.sql
   mysql -u root -p < sql/02_schema_update.sql
   mysql -u root -p < sql/03_sample_data.sql
   ```

3. Run the concurrent queries script:
   ```bash
   python scripts/multi_thread_queries.py
   ```

## Security Notes

- Never commit the `.secrets` file
- Use GitHub Secrets for sensitive information
- Keep your database credentials secure 