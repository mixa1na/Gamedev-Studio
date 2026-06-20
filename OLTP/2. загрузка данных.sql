BEGIN;

DROP TABLE IF EXISTS staging_employees;
DROP TABLE IF EXISTS staging_projects;
DROP TABLE IF EXISTS staging_games;
DROP TABLE IF EXISTS staging_employee_projects;

CREATE TEMP TABLE staging_employees (
    employee_name VARCHAR(150),
    email VARCHAR(150),
    hire_date VARCHAR(50),
    department VARCHAR(100),
    position VARCHAR(100)
);

CREATE TEMP TABLE staging_projects (
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50)
);

CREATE TEMP TABLE staging_games (
    game_name VARCHAR(100),
    genre VARCHAR(50),
    engine VARCHAR(50),
    project_name VARCHAR(100)
);

CREATE TEMP TABLE staging_employee_projects (
    email VARCHAR(150),
    project_name VARCHAR(100)
);

COPY staging_employees
FROM 'C:\Users\mini\Desktop\Gamedev_Studio\csv\employees.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ';',
    ENCODING 'UTF8'
);

COPY staging_projects
FROM 'C:\Users\mini\Desktop\Gamedev_Studio\csv\projects.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ';',
    ENCODING 'UTF8'
);

COPY staging_games
FROM 'C:\Users\mini\Desktop\Gamedev_Studio\csv\games.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ';',
    ENCODING 'UTF8'
);

COPY staging_employee_projects
FROM 'C:\Users\mini\Desktop\Gamedev_Studio\csv\employee_projects.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ';',
    ENCODING 'UTF8'
);

INSERT INTO departments (department_name)
SELECT DISTINCT department
FROM staging_employees
WHERE department IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO positions (position_name)
SELECT DISTINCT position
FROM staging_employees
WHERE position IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO genres (genre_name)
SELECT DISTINCT genre
FROM staging_games
WHERE genre IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO engines (engine_name)
SELECT DISTINCT engine
FROM staging_games
WHERE engine IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO project_statuses (status_name)
SELECT DISTINCT status
FROM staging_projects
WHERE status IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO projects (
    project_name,
    start_date,
    end_date,
    status_name
)
SELECT
    project_name,
    start_date,
    end_date,
    status
FROM staging_projects
ON CONFLICT (project_name) DO NOTHING;

INSERT INTO employees (
    email,
    employee_name,
    hire_date,
    department_name,
    position_name
)
SELECT
    email,
    employee_name,
    TO_DATE(hire_date, 'DD.MM.YYYY'),
    department,
    position
FROM staging_employees
ON CONFLICT (email) DO NOTHING;

INSERT INTO games (
    game_name,
    genre_name,
    engine_name,
    project_name
)
SELECT
    game_name,
    genre,
    engine,
    project_name
FROM staging_games
ON CONFLICT (game_name) DO NOTHING;

INSERT INTO employee_projects (
    email,
    project_name
)
SELECT
    email,
    project_name
FROM staging_employee_projects
ON CONFLICT (email, project_name) DO NOTHING;

COMMIT;

SELECT * FROM departments;
SELECT * FROM positions;
SELECT * FROM genres;
SELECT * FROM engines;
SELECT * FROM project_statuses;

SELECT * FROM projects;
SELECT * FROM employees;
SELECT * FROM games;
SELECT * FROM employee_projects;