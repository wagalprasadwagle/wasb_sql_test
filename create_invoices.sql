CREATE TABLE INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

CREATE TABLE SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR(100)
);

INSERT INTO SUPPLIER (supplier_id, name)
VALUES 
(1, 'Catering Plus'),
(2, 'Dave''s Discos'),  
(3, 'Entertainment Tonight'),
(4, 'Ice Ice Baby'),
(5, 'Party Animals');

INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES
-- Party Animals
(5, 6000.00, DATE_ADD('day', -1, DATE_ADD('month', 4, DATE_TRUNC('month', CURRENT_DATE)))),
-- Catering Plus (1st Invoice)
(1, 2000.00, DATE_ADD('day', -1, DATE_ADD('month', 3, DATE_TRUNC('month', CURRENT_DATE)))),
-- Catering Plus (2nd Invoice)
(1, 1500.00, DATE_ADD('day', -1, DATE_ADD('month', 4, DATE_TRUNC('month', CURRENT_DATE)))),
-- Dave's Discos
(2, 500.00, DATE_ADD('day', -1, DATE_ADD('month', 2, DATE_TRUNC('month', CURRENT_DATE)))),
-- Entertainment Tonight
(3, 6000.00, DATE_ADD('day', -1, DATE_ADD('month', 4, DATE_TRUNC('month', CURRENT_DATE)))),
-- Ice Ice Baby
(4, 4000.00, DATE_ADD('day', -1, DATE_ADD('month', 7, DATE_TRUNC('month', CURRENT_DATE))));



