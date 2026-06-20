BEGIN;

INSERT INTO olap_dwh.Dim_Genre (genre_name)
SELECT genre_name
FROM public.genres
ON CONFLICT DO NOTHING;

INSERT INTO olap_dwh.Dim_Engine (engine_name)
SELECT engine_name
FROM public.engines
ON CONFLICT DO NOTHING;

INSERT INTO olap_dwh.Dim_Project_Status (status_name)
SELECT status_name
FROM public.project_statuses
ON CONFLICT DO NOTHING;

INSERT INTO olap_dwh.Dim_Project (
    project_name,
    start_date,
    end_date,
    status_name
)
SELECT
    project_name,
    start_date,
    end_date,
    status_name
FROM public.projects
ON CONFLICT (project_name) DO NOTHING;

INSERT INTO olap_dwh.Dim_Game (
    game_name,
    genre_name,
    engine_name,
    project_name
)
SELECT
    game_name,
    genre_name,
    engine_name,
    project_name
FROM public.games
ON CONFLICT (game_name) DO NOTHING;

INSERT INTO olap_dwh.Dim_Employee (
    email,
    employee_name,
    department_name,
    position_name,
    dwh_start_date,
    dwh_end_date,
    is_current
)
SELECT
    e.email,
    e.employee_name,
    e.department_name,
    e.position_name,
    CURRENT_DATE,
    NULL,
    TRUE
FROM public.employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM olap_dwh.Dim_Employee de
    WHERE de.email = e.email
      AND de.is_current = TRUE
);

INSERT INTO olap_dwh.Bridge_Employee_Project (
    employee_sk,
    project_name
)
SELECT
    de.employee_sk,
    ep.project_name
FROM olap_dwh.Dim_Employee de
JOIN public.employee_projects ep
    ON de.email = ep.email
WHERE de.is_current = TRUE
ON CONFLICT DO NOTHING;

INSERT INTO olap_dwh.Fact_Project_Performance (
    project_name,
    total_duration_days,
    total_games_count
)
SELECT
    p.project_name,
    COALESCE(p.end_date, CURRENT_DATE) - p.start_date,
    COUNT(g.game_name)
FROM olap_dwh.Dim_Project p
LEFT JOIN olap_dwh.Dim_Game g
    ON p.project_name = g.project_name
GROUP BY
    p.project_name,
    p.end_date,
    p.start_date
ON CONFLICT (project_name)
DO UPDATE SET
    total_duration_days = EXCLUDED.total_duration_days,
    total_games_count = EXCLUDED.total_games_count;

INSERT INTO olap_dwh.Fact_Project_Staffing (
    project_name,
    total_assigned_employees
)
SELECT
    project_name,
    COUNT(employee_sk)
FROM olap_dwh.Bridge_Employee_Project
GROUP BY project_name
ON CONFLICT (project_name)
DO UPDATE SET
    total_assigned_employees = EXCLUDED.total_assigned_employees;

COMMIT;

SELECT * FROM olap_dwh.Dim_Genre;
SELECT * FROM olap_dwh.Dim_Engine;
SELECT * FROM olap_dwh.Dim_Project_Status;
SELECT * FROM olap_dwh.Dim_Project;
SELECT * FROM olap_dwh.Dim_Game;
SELECT * FROM olap_dwh.Dim_Employee;
SELECT * FROM olap_dwh.Fact_Project_Performance;
SELECT * FROM olap_dwh.Fact_Project_Staffing;