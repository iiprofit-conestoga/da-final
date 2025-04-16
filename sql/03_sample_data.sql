USE project_db;

-- Insert sample climate data
INSERT INTO ClimateData (location, record_date, temperature, precipitation, humidity) VALUES
('Toronto', '2024-04-01', 15.5, 2.3, 65.0),
('Vancouver', '2024-04-01', 12.8, 5.1, 75.0),
('Montreal', '2024-04-01', 13.2, 1.8, 70.0),
('Calgary', '2024-04-01', 8.5, 0.5, 55.0),
('Halifax', '2024-04-01', 10.2, 3.7, 80.0),
('Toronto', '2024-04-02', 16.2, 0.0, 60.0),
('Vancouver', '2024-04-02', 14.1, 3.2, 72.0),
('Montreal', '2024-04-02', 14.8, 2.1, 68.0),
('Calgary', '2024-04-02', 9.8, 0.2, 52.0),
('Halifax', '2024-04-02', 11.5, 4.2, 82.0); 