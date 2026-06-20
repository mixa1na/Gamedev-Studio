SELECT 
    department_name AS "Отдел", 
    position_name AS "Должность", 
    COUNT(*) AS "Количество сотрудников"
FROM public.employees
GROUP BY department_name, position_name
ORDER BY department_name ASC, "Количество сотрудников" DESC;

SELECT 
    employee_name AS "Имя", 
    email AS "Email", 
    hire_date AS "Дата найма",
    (CURRENT_DATE - hire_date) AS "Дней в компании"
FROM public.employees
ORDER BY hire_date ASC;

SELECT 
    p.project_name AS "Название проекта",
    g.game_name AS "Имя игры",
    g.engine_name AS "Игровой движок",
    p.start_date AS "Дата старта"
FROM public.projects p
JOIN public.games g ON p.project_name = g.project_name
WHERE p.status_name = 'In Development'
ORDER BY p.start_date DESC;