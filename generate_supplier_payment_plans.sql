-- Create a temporary table to store the supplier invoices
WITH invoice_data AS (
    SELECT
        s.supplier_id,
        s.name AS supplier_name,
        i.invoice_amount,  -- Correct invoice amount column
        i.due_date
    FROM
        SUPPLIER s
    JOIN
        INVOICE i ON s.supplier_id = i.supplier_id
    WHERE
        i.due_date > CURRENT_DATE
),

-- Calculate total outstanding balance for each supplier
balance_data AS (
    SELECT
        supplier_id,
        supplier_name,
        SUM(invoice_amount) AS total_balance_outstanding  -- Using invoice_amount for outstanding balance
    FROM
        invoice_data
    GROUP BY
        supplier_id, supplier_name
),

-- Determine payment amounts and next payment date
payment_plan AS (
    SELECT
        supplier_id,
        supplier_name,
        CASE
            WHEN total_balance_outstanding > 1500 THEN 1500
            ELSE total_balance_outstanding
        END AS payment_amount,
        total_balance_outstanding AS balance_outstanding,
        DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1' MONTH AS payment_date
    FROM
        balance_data
),

-- Create monthly installments until the balance is cleared
monthly_payments AS (
    SELECT
        supplier_id,
        supplier_name,
        payment_amount,
        balance_outstanding,
        payment_date,
        ROW_NUMBER() OVER (PARTITION BY supplier_id ORDER BY payment_date) AS month_number
    FROM
        payment_plan
)

SELECT
    supplier_id,
    supplier_name,
    payment_amount,
    balance_outstanding,
    payment_date + (month_number - 1) * INTERVAL '1' MONTH AS payment_date
FROM
    monthly_payments
WHERE
    balance_outstanding > 0
ORDER BY
    supplier_id, payment_date;
