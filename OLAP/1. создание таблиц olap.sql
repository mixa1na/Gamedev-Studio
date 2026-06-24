DROP SCHEMA IF EXISTS olap_dwh CASCADE;

CREATE SCHEMA IF NOT EXISTS olap_dwh;

CREATE TABLE IF NOT EXISTS olap_dwh.Dim_Genre (genre_name VARCHAR(50) PRIMARY KEY);
CREATE TABLE IF NOT EXISTS olap_dwh.Dim_Engine (engine_name VARCHAR(50) PRIMARY KEY);
CREATE TABLE IF NOT EXISTS olap_dwh.Dim_Project_Status (status_name VARCHAR(50) PRIMARY KEY);


CREATE TABLE IF NOT EXISTS olap_dwh.Dim_Project (
    project_name VARCHAR(100) PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE,
    status_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (status_name) REFERENCES olap_dwh.Dim_Project_Status(status_name)
);

CREATE TABLE IF NOT EXISTS olap_dwh.Dim_Game (
    game_name VARCHAR(100) PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL,
    engine_name VARCHAR(50) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (genre_name) REFERENCES olap_dwh.Dim_Genre(genre_name),
    FOREIGN KEY (engine_name) REFERENCES olap_dwh.Dim_Engine(engine_name),
    FOREIGN KEY (project_name) REFERENCES olap_dwh.Dim_Project(project_name)
);

CREATE TABLE IF NOT EXISTS olap_dwh.Dim_Employee (
    employee_sk SERIAL PRIMARY KEY,
    email VARCHAR(150) NOT NULL,
    employee_name VARCHAR(150) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    position_name VARCHAR(100) NOT NULL,
    dwh_start_date DATE NOT NULL,
    dwh_end_date DATE,
    is_current BOOLEAN NOT NULL
);


CREATE TABLE IF NOT EXISTS olap_dwh.Bridge_Employee_Project (
    employee_sk INT NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee_sk, project_name),
    FOREIGN KEY (employee_sk) REFERENCES olap_dwh.Dim_Employee(employee_sk),
    FOREIGN KEY (project_name) REFERENCES olap_dwh.Dim_Project(project_name)
);


CREATE TABLE IF NOT EXISTS olap_dwh.Fact_Project_Performance (
    project_name VARCHAR(100) PRIMARY KEY,
    total_duration_days INT,
    total_games_count INT NOT NULL,
    FOREIGN KEY (project_name) REFERENCES olap_dwh.Dim_Project(project_name)
);

CREATE TABLE IF NOT EXISTS olap_dwh.Fact_Project_Staffing (
    project_name VARCHAR(100) PRIMARY KEY,
    total_assigned_employees INT NOT NULL,
    FOREIGN KEY (project_name) REFERENCES olap_dwh.Dim_Project(project_name)
);
