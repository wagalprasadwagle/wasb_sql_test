-- Create a temporary table to store the supplier invoices
WITH invoice_data AS (
    SELECT 
        s.supplier_id,
        s.name AS supplier_name,
        i.amount AS invoice_amount,
        i.due_date,
        i.balance_outstanding
    FROM 
        SUPPLIER s
    JOIN 
        INVOICE i ON s.supplier_id = i.supplier_id
    WHERE 
        i.due_date > CURRENT_DATE
),

-- Calculate payment plans based on the outstanding balance
payment_plan AS (
    SELECT 
        supplier_id,
        supplier_name,
        CASE 
            WHEN balance_outstanding > 1500 THEN 1500 
            ELSE balance_outstanding 
        END AS payment_amount,
        SUM(balance_outstanding) OVER (PARTITION BY supplier_id) AS balance_outstanding,
        DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1' MONTH AS payment_date
    FROM 
        invoice_data
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
    payment_date + INTERVAL (month_number - 1) MONTH AS payment_date
FROM 
    monthly_payments
WHERE 
    balance_outstanding > 0
ORDER BY 
    supplier_id, payment_date;
