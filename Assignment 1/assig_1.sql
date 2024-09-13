-- ***********************
-- Names & IDs:   Hiu Fung Chan (106184237),
--                Henry Lau (121235238),
--                Trung Kien Phan (123266231)
-- Date:          15 June 2024
-- Purpose:       Assignment 1 DBS311 (Group 9)
-- ***********************

-- Question 1 - Display the employee number, full employee name, job title, and hire date of all employees hired
--              in September with the most recently hired employees displayed first.

-- Q1 SOLUTION --
SELECT
    employee_id                                    AS "Employee Number",
    first_name
    || last_name                                   AS "Full Name",
    job_title                                      AS "Job Title",
    to_char(hire_date, '[fmMonth ddth "of" YYYY]') AS "Start Date"
FROM
    employees
WHERE
    EXTRACT(MONTH FROM hire_date) = 9
ORDER BY
    hire_date DESC;

-- Question 2 - Display the salesman ID and the total sale amount for the employee for each employee.
--              Sort the result according to employee number.

-- Q2 SOLUTION --

SELECT
    nvl(e.employee_id, 0)                                              AS "Employee Number",
    to_char(SUM(oi.quantity * oi.unit_price), 'fm$999,999,999,999.00') AS "Total Sale"
FROM
    orders      o
    LEFT JOIN employees e
    ON o.salesman_id = e.employee_id
    LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    e.employee_id
ORDER BY
    e.employee_id NULLS FIRST;

-- Question 3 - Display customer Id, customer name and total number of orders for customers that the value of
--              their customer Id is in values from 35 to 45. Include the customers with no orders in your report
--              if their customer Id falls in the range 35 and 45. Sort the result by the value of total orders.

-- Q3 SOLUTION --
SELECT
    o.customer_id             AS "Customer Id",
    c.name                    AS "Name",
    nvl(COUNT(o.order_id), 0) AS "Total Orders"
FROM
    customers c
    LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE
    o.customer_id BETWEEN 35 AND 45
GROUP BY
    o.customer_id,
    c.name
ORDER BY
    COUNT(o.order_id) NULLS FIRST;

-- Question 4 - Display customer Id, customer name, and the order id and the order date of all
--              orders for customer whose ID is 44.

-- Q4 SOLUTION --

SELECT
    c.customer_id                                                  AS "Customer Id",
    c.name                                                         AS "Name",
    o.order_id                                                     AS "Order Id",
    o.order_date                                                   AS "Order Date",
    SUM(oi.quantity)                                               AS "Total Items",
    to_char(SUM(oi.quantity * oi.unit_price), 'fm$999,999,999.00') AS "Total Amount"
FROM
    orders      o
    JOIN customers c
    ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE
    o.customer_id = 44
GROUP BY
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date
ORDER BY
    SUM(oi.quantity * oi.unit_price) DESC;

-- Question 5 - Display customer Id, name, total number of orders, the total number of items ordered, and the total
--              order amount for customers who have more than 30 orders. Sort the result
--              based on the total number of orders.

-- Q5 SOLUTION --

SELECT
    c.customer_id                                                  AS "Customer Id",
    c.name                                                         AS "Name",
    COUNT(o.order_id)                                              AS "Total Number of Orders",
    SUM(oi.quantity)                                               AS "Total Items",
    to_char(SUM(oi.quantity * oi.unit_price), 'fm$999,999,999.00') AS "Total Amount"
FROM
    orders      o
    JOIN customers c
    ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.name,
    o.order_id
HAVING
    COUNT(o.order_id) > 30
ORDER BY
    COUNT(o.order_id);

-- Question 6 - Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product
--              standard cost for this combination.

-- Q6 SOLUTION --
desc warehouses;

SELECT
    w.warehouse_id                                     AS "Warehouse ID",
    w.warehouse_name                                   AS "Warehouse Name",
    pc.category_id                                     AS "Category ID",
    pc.category_name                                   AS "Category Name",
    to_char(MIN(p.standard_cost), 'fm$999,999,999.00') AS "Lowest Cost"
FROM
    warehouses         w
    JOIN inventories i
    ON w.warehouse_id = i.warehouse_id
    JOIN products p
    ON p.product_id = i.product_id
    JOIN product_categories pc
    ON p.category_id = pc.category_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name,
    pc.category_id,
    pc.category_name
HAVING
    MIN(p.standard_cost) NOT BETWEEN 200 AND 500
ORDER BY
    w.warehouse_id,
    w.warehouse_name,
    pc.category_id,
    pc.category_name;

-- Question 7 - Display the total number of orders per month. Sort the result from January to December.

-- Q7 SOLUTION --
SELECT
    to_char(to_date(EXTRACT(MONTH FROM order_date), 'fmMM'), 'Month') AS "Month",
    COUNT(order_id)                                                   AS "Number of Orders"
FROM
    orders
GROUP BY
    EXTRACT(MONTH FROM order_date)
ORDER BY
    EXTRACT(MONTH FROM order_date);

-- SELECT
--     to_char(to_date(month_1, 'MM'), 'Month') AS "Month",
--     COUNT(order_id)                          AS "Number of Orders"
-- FROM
--     (
--         SELECT
--             order_id,
--             EXTRACT(MONTH FROM order_date) AS month_1
--         FROM
--             orders
--     )
-- GROUP BY
--     month_1
-- ORDER BY
--     month_1;

-- Question 8 - Display product Id, product name for products that their list price is more than any highest product standard
--              cost per warehouse outside Americas regions.

-- Q8 SOLUTION --
SELECT
    *
FROM
    regions;

SELECT
    product_id   AS "Product ID",
    product_name AS "Product Name",
    list_price   AS "Price"
FROM
    products
WHERE
    list_price > (
        SELECT
            MAX(list_price)
 -- r.region_name
 -- *
        FROM
            regions     r
            JOIN countries c
            ON r.region_id = c.region_id
            JOIN locations l
            ON l.country_id = c.country_id
            JOIN warehouses w
            ON w.location_id = l.location_id
            JOIN inventories i
            ON i.warehouse_id = w.warehouse_id
            JOIN products p
            ON p.product_id = i.product_id
        WHERE
            lower(r.region_name) <> 'americas'
        GROUP BY
            r.region_name
    );

-- Question 9 - Write a SQL statement to display the most expensive and the cheapest product (list price).
--              Display product ID, product name, and the list price.

-- Q9 SOLUTION --
-- SELECT
--     product_id                               AS "Product ID",
--     product_name                             AS "Product Name",
--     to_char(list_price, 'fm$999,999,999.00') AS "Price"
-- FROM
--     products
-- WHERE
--     list_price = (
--         SELECT
--             MAX(list_price)
--         FROM
--             products
--     )
--     OR list_price = (
--         SELECT
--             MIN(list_price)
--         FROM
--             products
--     );

SELECT
    product_id                               AS "Product ID",
    product_name                             AS "Product Name",
    to_char(list_price, 'fm$999,999,999.00') AS "Price"
FROM
    (
        SELECT
            p1.product_id,
            p1.product_name,
            p2.list_price
        FROM
            products p1
            JOIN (
                SELECT
                    MAX(list_price) AS list_price
                FROM
                    products
            ) p2
            ON p1.list_price = p2.list_price
        UNION
        SELECT
            p1.product_id,
            p1.product_name,
            p2.list_price
        FROM
            products p1
            JOIN (
                SELECT
                    MIN(list_price) AS list_price
                FROM
                    products
            ) p2
            ON p1.list_price = p2.list_price
    );        

-- Question 10 - Write a SQL query to display the number of customers with total order amount over the average amount of all products,
--               the number of customers with total order amount under the average amount of all products, number of
--               customer with no orders, and the total number of customers.

-- Q10 SOLUTION --
-- above avg
SELECT
    'Number of customers with total purchase amount over average: '
FROM
    products;

-- avg purchase amount
SELECT
    avg(oi.unit_price * oi.quantity) AS amount
FROM
    orders      o
    JOIN order_items oi
    ON o.order_id = oi.order_id;

-- total purchase amount of customers
WITH customer_total_purchase_amount AS (
    SELECT
        o.customer_id,
        SUM(oi.unit_price * oi.quantity) AS amount
    FROM
        orders      o
        JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id
)
 -- above avg
SELECT
    'Number of customers with total purchase amount over average: '
    || COUNT(customer_id)   AS "Customer Report"
FROM
    customer_total_purchase_amount oa
WHERE
    oa.amount > (
        SELECT
            AVG(list_price) AS list_price
        FROM
            products
    )
UNION
ALL
SELECT
    'Number of customers with total purchase amount below average: '
    || COUNT(customer_id)   AS "Customer Report"
FROM
 -- (
 --     SELECT
 --         o.customer_id,
 --         SUM(oi.unit_price) AS amount
 --     FROM
 --         orders      o
 --         JOIN order_items oi
 --         ON o.order_id = oi.order_id
 --     GROUP BY
 --         o.customer_id
 -- )                        oa
    customer_total_purchase_amount oa
WHERE
    oa.amount < (
        SELECT
            AVG(list_price)
        FROM
            products
    )
UNION
ALL
 -- customers without orders
SELECT
    'Number of customers with no orders: '
    || COUNT(c.customer_id) AS "Customer Report"
FROM
    customers                c
    LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE
    o.order_id IS NULL
UNION
ALL
 -- total customers
SELECT
    'Total number of customers: '
    || COUNT(customer_id)   AS "Customer Report"
FROM
    customers;