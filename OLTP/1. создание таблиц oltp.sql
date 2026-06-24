DROP TABLE IF EXISTS games CASCADE;
DROP TABLE IF EXISTS employee_projects CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS project_statuses CASCADE;
DROP TABLE IF EXISTS engines CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS positions CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    department_name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE positions (
    position_name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE employees (
    email VARCHAR(150) PRIMARY KEY,
    employee_name VARCHAR(150) NOT NULL,
    hire_date DATE NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    position_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (department_name) REFERENCES departments(department_name) ON UPDATE CASCADE,
    FOREIGN KEY (position_name) REFERENCES positions(position_name) ON UPDATE CASCADE,
    CONSTRAINT chk_email CHECK (email LIKE '%@%')
);

CREATE TABLE genres (
    genre_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE engines (
    engine_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE project_statuses (
    status_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE projects (
    project_name VARCHAR(100) PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE,
    status_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (status_name) REFERENCES project_statuses(status_name) ON UPDATE CASCADE,
    CONSTRAINT chk_dates CHECK (end_date IS NULL OR start_date <= end_date)
);

CREATE TABLE employee_projects (
    email VARCHAR(150),
    project_name VARCHAR(100),
    PRIMARY KEY (email, project_name),
    FOREIGN KEY (email) REFERENCES employees(email) ON UPDATE CASCADE,
    FOREIGN KEY (project_name) REFERENCES projects(project_name) ON UPDATE CASCADE
);

CREATE TABLE games (
    game_name VARCHAR(100) PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL,
    engine_name VARCHAR(50) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (genre_name) REFERENCES genres(genre_name) ON UPDATE CASCADE,
    FOREIGN KEY (engine_name) REFERENCES engines(engine_name) ON UPDATE CASCADE,
    FOREIGN KEY (project_name) REFERENCES projects(project_name) ON UPDATE CASCADE
);
