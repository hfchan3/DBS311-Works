-- ***********************
-- Names & IDs: Hiu Fung Chan (106184237),
--              Henry Lau (121235238),
--              Trung Kien Phan (123266231)
-- Date: 4 June 2024
-- Purpose: Lab 4 DBS311 (Group 9)
-- ***********************

-- Question 1: Display cities that no warehouse is located in them. (use set operators to answer this question)
-- Q1 SOLUTION --
DESC LOCATIONS;
DESC WAREHOUSES;

SELECT l.city
FROM LOCATIONS l
WHERE l.location_ID IN (
                        SELECT l.location_ID
                        FROM LOCATIONS l
                        MINUS
                        SELECT w.location_ID
                        FROM WAREHOUSES w
)
ORDER BY CITY;

-- Question 2: Display the category ID, category name, and the number of products in category 1, 2, and 5. In your result, display first the number of products in category 5, then category 1 and then 2.
-- Q2 SOLUTION --
DESC PRODUCT_CATERGORIES;
DESC PRODUCTS;

SELECT pc.CATEGORY_ID, pc.CATEGORY_NAME, COUNT(*)
FROM PRODUCT_CATEGORIES pc JOIN PRODUCTS p ON pc.CATEGORY_ID = p.CATEGORY_ID
WHERE pc.CATEGORY_ID = 5
GROUP BY pc.CATEGORY_ID, pc.CATEGORY_NAME
UNION ALL
SELECT pc.CATEGORY_ID, pc.CATEGORY_NAME, COUNT(*)
FROM PRODUCT_CATEGORIES pc JOIN PRODUCTS p ON pc.CATEGORY_ID = p.CATEGORY_ID
WHERE pc.CATEGORY_ID = 1
GROUP BY pc.CATEGORY_ID, pc.CATEGORY_NAME
UNION ALL
SELECT pc.CATEGORY_ID, pc.CATEGORY_NAME, COUNT(*)
FROM PRODUCT_CATEGORIES pc JOIN PRODUCTS p ON pc.CATEGORY_ID = p.CATEGORY_ID
WHERE pc.CATEGORY_ID = 2
GROUP BY pc.CATEGORY_ID, pc.CATEGORY_NAME;

    
-- Question 3: Display product ID for products whose quantity in the inventory is less than to 5. (You are not allowed to use JOIN for this question.)
-- Q3 SOLUTION --
DESC PRODUCTS;
DESC INVENTORIES;

SELECT p.PRODUCT_ID
FROM PRODUCTS p
INTERSECT
SELECT i.PRODUCT_ID
FROM INVENTORIES i
WHERE QUANTITY < 5;

-- Question 4: We need a single report to display all warehouses and the state that they are located in and all states regardless of whether they have warehouses in them or not. (Use set operators in you answer.)
-- Q4 SOLUTION --
DESC WAREHOUSES;
DESC LOCATIONS;

SELECT w.WAREHOUSE_NAME, l.STATE
FROM WAREHOUSES w LEFT JOIN LOCATIONS l ON w.LOCATION_ID = l.LOCATION_ID
UNION
SELECT w.WAREHOUSE_NAME, l.STATE 
FROM LOCATIONS l LEFT JOIN WAREHOUSES w ON l.LOCATION_ID = w.LOCATION_ID
WHERE w.LOCATION_ID IS NULL
ORDER BY WAREHOUSE_NAME, STATE; 