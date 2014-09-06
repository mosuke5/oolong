#計測データ格納テーブル
CREATE TABLE measurement_data (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    machine_id int NOT NULL,
    measured_date datetime NOT NULL,
    humidity DOUBLE,
    temperature DOUBLE,
    created_at datetime DEFAULT CURRENT_TIMESTAMP
);
