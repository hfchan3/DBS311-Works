-- ***********************
-- Names & IDs:   Hiu Fung Chan (106184237),
--                Henry Lau (121235238),
--                Trung Kien Phan (123266231)
-- Date:          18 May 2024
-- Purpose:       Lab 1 DBS311 (Group 9)
-- ***********************

-- Question 1 - Write a query to display the tomorrow’s date in the following format:
--              January 10th of year 2019
--              the result will depend on the day when you RUN/EXECUTE this query.  Label the column “Tomorrow”.

-- Q1 SOLUTION --
SELECT TO_CHAR(current_date + 1, 'fmMonth ddth "of year" YYYY') "Tomorrow"
FROM dual;

-- Question 2 - For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list 
--              price increased by 2%. Display a new list price as a whole number. In your result, add a calculated 
--              column to show the difference of old and new list prices.

-- Q2 SOLUTION --
DESC PRODUCTS;

SELECT product_id, product_name, list_price, ROUND(list_price * 1.02) AS new_list_price,  ROUND((list_price * 1.02) - list_price) AS price_difference
FROM PRODUCTS
WHERE category_id IN (2,3,5)
ORDER BY category_id, product_id;

-- Question 3 - For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title 
--              in the following format:  SUMMER, PAYNE is Public Accountant.

-- Q3 SOLUTION --
DESC EMPLOYEES;

SELECT UPPER(first_name) || ', ' || UPPER(last_name) || ' is ' || job_title AS "Employee Details"
FROM EMPLOYEES
WHERE manager_id = 2
ORDER BY employee_id;

-- Question 4 - For each employee hired before October 2016, display the employee’s last name, hire date and calculate the 
--             number of YEARS between TODAY and the date the employee was hired.
--             •	Label the column Years worked. 
--             •	Order your results by the number of years employed.  Round the number of years employed up to the closest 
--                  whole number.

-- Q4 SOLUTION --
DESC EMPLOYEES;

SELECT last_name, hire_date, ROUND(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date)) AS "Years worked"
FROM EMPLOYEES
WHERE hire_date < TO_DATE('1-10-2016', 'DD-MM-YYYY')
ORDER BY "Years worked";

--Question 5 - Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of 
--             service, but only for those hired after 2016.  
--             •	Label the column REVIEW DAY. 
--             •	Format the dates to appear in the format like: TUESDAY, August the Thirty-First of year 2016
--             •	Sort by review date

-- Q5 SOLUTION --
DESC EMPLOYEES;

SELECT last_name, 
       hire_date, 
       TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY'), 'fmDAY, Month "the" Ddspth "of year" YYYY') AS "Review Date"
FROM EMPLOYEES
WHERE hire_date > TO_DATE('01-JAN-2016', 'DD-MON-YYYY')
ORDER BY "Review Date";

-- Question 6 - For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value 
--              for the state column, display “unknown”.

-- Q6 SOLUTION --
DESC WAREHOUSES;
DESC LOCATIONS;

SELECT w.warehouse_id, w.warehouse_name, l.city, NVL(l.state, 'unknown') AS "STATE"
FROM WAREHOUSES w
JOIN LOCATIONS l ON w.location_id = l.location_id
ORDER BY warehouse_id;



