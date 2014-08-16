CREATE TABLE measurement_data (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    measured_at TIMESTAMP,
    humidity DOUBLE,
    temperature DOUBLE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE measurement_data2 (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    measured_date DATE,
    measured_time INT(11),
    humidity DOUBLE,
    temperature DOUBLE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
