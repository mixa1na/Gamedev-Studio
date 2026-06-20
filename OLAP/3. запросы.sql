SELECT 
    p.status_name AS "Статус проекта",
    COUNT(f.project_name) AS "Количество проектов",
    SUM(f.total_games_count) AS "Всего создано игр",
    ROUND(AVG(f.total_duration_days), 0) AS "Средняя длительность (дней)"
FROM olap_dwh.Fact_Project_Performance f
JOIN olap_dwh.Dim_Project p ON f.project_name = p.project_name
GROUP BY p.status_name
ORDER BY "Количество проектов" DESC;

SELECT 
    s.project_name AS "Название проекта",
    p.status_name AS "Текущий статус",
    s.total_assigned_employees AS "Размер команды",
    perf.total_duration_days AS "Дней в разработке"
FROM olap_dwh.Fact_Project_Staffing s
JOIN olap_dwh.Dim_Project p ON s.project_name = p.project_name
JOIN olap_dwh.Fact_Project_Performance perf ON s.project_name = perf.project_name
ORDER BY s.total_assigned_employees DESC;

SELECT
    de.department_name,
    COUNT(bep.project_name) AS total_assignments
FROM olap_dwh.Dim_Employee de
JOIN olap_dwh.Bridge_Employee_Project bep
    ON de.employee_sk = bep.employee_sk
WHERE de.is_current = TRUE
GROUP BY de.department_name
ORDER BY total_assignments DESC;
