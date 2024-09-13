-- ***********************
-- Names & IDs: Hiu Fung Chan (106184237),
--              Henry Lau (121235238),
--              Trung Kien Phan (123266231)
-- Date: 23 May 2024
-- Purpose: Lab 2 DBS311 (Group 9)
-- ***********************

-- Question 1 – For each job title, display the number of employees. Sort the result according to the number of employees.
-- Q1 SOLUTION --
desc employees;

SELECT
    job_title,
    count(job_title) AS "EMPLOYEES"
FROM
    employees
GROUP BY
    job_title
ORDER BY
    employees;

-- Question 2 – Display the highest, lowest, and average customer credit limits. Name these results high, low, and average. Add a column that shows the difference between the highest and the lowest credit limits named “High and Low Difference”. Round the average to 2 decimal places.
-- Q2 SOLUTION --
desc customers;

SELECT
    max(credit_limit)                     AS "HIGH",
    min(credit_limit)                     AS "LOW",
    round(avg(credit_limit), 2)           AS "AVERAGE",
    max(credit_limit) - min(credit_limit) AS "High Low Difference"
FROM
    customers;

-- Question 3 – Display the order id, the total number of products, and the total order amount for orders with the total amount over $1,000,000. Sort the result based on total amount from the high to low values.
-- Q3 SOLUTION --
desc order_items;

SELECT
    *
FROM
    (
        SELECT
            order_id,
            SUM(quantity)              AS "TOTAL_ITEMS",
            SUM(quantity * unit_price) AS "TOTAL_AMOUNT"
        FROM
            order_items
        GROUP BY
            order_id
    )
WHERE
    "TOTAL_AMOUNT" > 1000000
ORDER BY
    "TOTAL_AMOUNT" DESC;

-- SELECT
--     ORDER_ID,
--     sum(QUANTITY) as "TOTAL_ITEMS",
--     sum(QUANTITY * UNIT_PRICE) as "TOTAL_AMOUNT"
-- from ORDER_ITEMS
-- group by ORDER_ID
-- HAVING sum(QUANTITY * UNIT_PRICE) > 1000000
-- order by "TOTAL_AMOUNT" desc;

-- Question 4 – Display the warehouse id, warehouse name, and the total number of products for each warehouse. Sort the result according to the warehouse ID.
-- Q4 SOLUTION --
desc warehouses;

desc inventories;

SELECT
    w.warehouse_id,
    w.warehouse_name,
    SUM(i.quantity)  AS "TOTAL_PRODUCTS"
FROM
    warehouses  w
    JOIN inventories i
    ON w.warehouse_id = i.warehouse_id
GROUP BY
    w.WARehouse_id,
    w.warehouse_name
ORDER BY
    w.warehouse_id;

-- Question 5 – For each customer, display customer number, customer full name, and the total number of orders issued by the customer.
-- Q5 SOLUTION --
desc customers;

desc orders;

SELECT
    C.customeR_ID,
    C.name                    AS "customer name",
    NVL(COUNT(O.order_id), 0) AS "total number OF orders"
FROM
    customeRS C
    LEFT JOIN orders O
    ON C.customer_id = O.customer_id
WHERE
    C.name liKE 'O%e%'
    OR C.name lIKE '%t'
GROUP BY
    C.customer_id,
    C.name
ORDER BY
    "total number OF orders" DESC;

-- Question 6 – Write a SQL query to show the total and the average sale amount for each category. Round the average to 2 decimal places.
-- Q6 SOLUTION --

desc order_items;

desc products;

SELECT
    P.category_id,
    ROUND(SUM(OI.quantity * oi.unit_price), 2) AS "TOTAL_AMOUNT",
    ROUND(AVG(OI.quantity * oi.unit_price), 2) AS "AVERAGE_AMOUNT"
FROM
    order_items OI
    JOIN products P
    ON OI.product_id = P.product_id
GROUP BY
    P.category_id;
