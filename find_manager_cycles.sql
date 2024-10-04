SET SESSION max_recursion_depth = 20;

SET SESSION distinct_aggregations_strategy = 'single_step';

WITH RECURSIVE employee_cycles(employee_id, manager_id, cycle_path, depth) AS (
    SELECT
        employee_id,
        manager_id,
        CAST(employee_id AS VARCHAR) AS cycle_path,
        1 AS depth
    FROM
        EMPLOYEE

    UNION ALL

    SELECT
        e.employee_id,
        e.manager_id,
        CAST(ec.cycle_path || ',' || CAST(e.manager_id AS VARCHAR) AS VARCHAR),
        ec.depth + 1
    FROM
        EMPLOYEE e
    JOIN
        employee_cycles ec ON e.manager_id = ec.employee_id
    WHERE
        ec.depth < 5  -- Limit recursion depth
)

SELECT
    employee_id,
    cycle_path
FROM
    employee_cycles;

--Query 20241004_112801_00048_mxiwd failed: Number of stages in the query (254) exceeds the allowed maximum (150). If the query contains multiple aggregates with DISTINCT over different columns, please set the 'distinct_aggregations_strategy' session property to 'single_step'. If the query contains WITH clauses that are referenced more than once, please create temporary table(s) for the queries in those clauses.

 
 