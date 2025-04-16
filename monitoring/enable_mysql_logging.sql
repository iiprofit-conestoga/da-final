-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1.0;  -- Log queries that take more than 1 second
SET GLOBAL slow_query_log_file = '/var/log/mysql/slow-query.log';

-- Enable performance schema
UPDATE performance_schema.setup_instruments 
SET ENABLED = 'YES', TIMED = 'YES' 
WHERE NAME LIKE '%statement/%';

UPDATE performance_schema.setup_consumers 
SET ENABLED = 'YES' 
WHERE NAME LIKE '%events_statements_%';

-- Enable error log
SET GLOBAL log_error = '/var/log/mysql/error.log';

-- Create a user for SignOz monitoring with limited permissions
CREATE USER IF NOT EXISTS 'signoz_user'@'%' IDENTIFIED BY 'signoz_password';
GRANT SELECT ON performance_schema.* TO 'signoz_user'@'%';
GRANT SELECT ON information_schema.* TO 'signoz_user'@'%';
GRANT SELECT ON mysql.* TO 'signoz_user'@'%';
GRANT SELECT ON project_db.* TO 'signoz_user'@'%';
FLUSH PRIVILEGES; 