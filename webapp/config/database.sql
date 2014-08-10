CREATE TABLE measurement_data (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    measured_at TIMESTAMP,
    humidity DOUBLE,
    temperature DOUBLE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
