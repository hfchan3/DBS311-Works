-- ***********************
-- Names & IDs: Hiu Fung Chan (106184237),
--              Henry Lau (121235238),
--              Trung Kien Phan (123266231)
-- Date: 23 May 2024
-- Purpose: Lab 2 DBS311 (Group 9)
-- ***********************
-- Question 1 – 

DESC employees;
SELECT first_name, hire_date
FROM employees
WHERE 
    hire_date BETWEEN TO_DATE('01-04-2016','DD-MM-YYYY') AND (
        SELECT hire_date
        FROM employees
        WHERE employee_id = 107
    ) - 1
ORDER BY hire_date, employee_id;


-- Question 2. Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort the result by customer ID
SELECT name, credit_limit
FROM customers
WHERE credit_limit = (SELECT MIN(credit_limit) FROM customers)
ORDER BY customer_id;

desc customers


-- Question 3. Write a SQL query to display the product_id
SELECT p.category_id, p.product_id, p.product_name, p.list_price
FROM products p
JOIN (
    SELECT 
        p.category_id,
        MAX(list_price) as "list-p"
    FROM
        products p
    JOIN product_categories pc
    ON p.category_id = pc.category_id
    GROUP BY p.category_id
) pc_table
ON p.list_price = pc_table."list-p"
ORDER BY p.category_id, p.product_id;




-- Question 4. Write a SQL query to display the category ID and the category name of the most expensive (highest list price) product(s).
SELECT pc.category_id, pc.category_name 
FROM product_categories pc
JOIN products p ON pc.category_id = p.category_id
WHERE p.list_price = (
    SELECT MAX(list_price) 
    FROM products
);


-- Question 5. Write a SQL query to display product name and list price for products in category 1 which have the list price less than the DELETE
DESC products;
SELECT product_name, list_price 
FROM products p
WHERE p.category_id = 1
AND p.list_price < ANY (
    SELECT MIN(list_price)
    FROM products p
    GROUP BY p.category_id
)
ORDER BY list_price DESC;


-- Question 6. Display the maximum price(list price) of the category(s) has the lowest price product.
SELECT
    MAX(list_price)
FROM
    products p
WHERE 
    category_id IN (
        SELECT p.category_id 
        FROM products p
        WHERE list_price = (
            SELECT MIN(p.list_price)
            FROM products
        )
    );
