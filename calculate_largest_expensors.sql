
-- Calculate the total expensed amount for each employee
WITH expense_totals AS (
    SELECT
        employee_id,
        employee_name,
        SUM(EXPENSE.unit_price * EXPENSE.quantity) AS total_expensed_amount
    FROM
        EXPENSE
    JOIN
        EMPLOYEE ON EXPENSE.employee_id = EMPLOYEE.employee_id
    GROUP BY
        employee_id, employee_name
)

-- Retrieve the manager information and filter for total expensed amount
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.manager_id,
    m.first_name || ' ' || m.last_name AS manager_name,
    et.total_expensed_amount
FROM
    expense_totals et
JOIN
    EMPLOYEE e ON et.employee_id = e.employee_id
LEFT JOIN
    EMPLOYEE m ON e.manager_id = m.employee_id
WHERE
    et.total_expensed_amount > 1000
ORDER BY
    et.total_expensed_amount DESC;
