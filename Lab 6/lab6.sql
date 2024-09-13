-- ***********************
-- Names & IDs: Hiu Fung Chan (106184237),
--              Henry Lau (121235238),
--              Trung Kien Phan (123266231)
-- Date: 03 Jul 2024
-- Purpose: Lab 6 DBS311 (Group 9)
-- ***********************

/*
    Question 1 -    Write a store procedure that gets an integer number n and calculates and displays its factorial

                    Example:
                    0! = 1
                    2! = fact(2) = 2 * 1 = 1
                    3! = fact(3) = 3 * 2 * 1 = 6
                    . . .
                    n! = fact(n) = n * (n-1) * (n-2) * . . . * 1
*/
-- Q1 SOLUTION --
CREATE OR REPLACE PROCEDURE calfactorial(
    num IN NUMBER
) AS
    factorial NUMBER := 1;
BEGIN
    FOR i IN 1..num LOOP
        factorial := factorial * i;
    END LOOP;

    dbms_output.put_line (num
                          || '! = '
                          || factorial);
END calfactorial;

BEGIN
    calfactorial(&input);
END;
 /*
    Question 2 -    The company wants to calculate the employees’ annual salary:
                    The first year of employment, the amount of salary is the base salary which is $10,000.
                    Every year after that, the salary increases by 5%.
                    Write a stored procedure named calculate_salary which gets an employee ID and for that
                    employee calculates the salary based on the number of years the employee has been working
                    in the company. (Use a loop construct to calculate the salary).
                    The procedure calculates and prints the salary.

                    Sample output:
                    First Name: first_name
                    Last Name: last_name
                    Salary: $9999,99
                    If the employee does not exists, the procedure displays a proper message.
*/
 -- Q2 SOLUTION --
 CREATE OR REPLACE PROCEDURE calculate_salary( empid IN NUMBER ) AS
    salary NUMBER := 10000;
    fname  employees.first_name%type;
    lname  employees.last_name%type;
    hdate  employees.hire_date%type;
BEGIN
    SELECT
        first_name,
        last_name,
        hire_date INTO fname,
        lname,
        hdate
    FROM
        employees
    WHERE
        employee_id = empid;
    FOR i IN 1..extract(year FROM sysdate) - extract(year FROM hdate) LOOP
        salary := salary * 1.05;
    END LOOP;

    dbms_output.put_line ('First name: '
                          || fname);
    dbms_output.put_line ('Last name: '
                          || lname);
    dbms_output.put_line ('Salary: '
                          || round(salary, 3));
END calculate_salary;

BEGIN
    calculate_salary(&empid);
END;
 /*
    Question 3 -    Write a stored procedure named warehouses_report to print the warehouse ID, warehouse
                    name, and the city where the warehouse is located in the following format for all warehouses:

                    Warehouse ID:
                    Warehouse name:
                    City:
                    State:

                    If the value of state does not exist (null), display “no state”.
                    The value of warehouse ID ranges from 1 to 9.
                    You can use a loop to find and display the information of each warehouse inside the loop.
                    (Use a loop construct to answer this question. Do not use cursors.)
*/
 -- Q3 SOLUTION --
 CREATE OR REPLACE PROCEDURE warehouses_report AS
    wid   warehouses.warehouse_id%type;
    wname warehouses.warehouse_name%type;
    city  locations.city%type;
    state locations.state%type;
BEGIN
    FOR i IN 1..9 LOOP
        SELECT
            w.warehouse_id,
            w.warehouse_name,
            l.city,
            l.state INTO wid,
            wname,
            city,
            state
        FROM
            warehouses w
            JOIN locations l
            ON w.location_id = l.location_id;
        dbms_output.put_line ('Warehouse ID: '
                              || wid);
        dbms_output.put_line ('Warehouse name: '
                              || wname);
        dbms_output.put_line ('City: '
                              || city);
        dbms_output.put_line ('State: '
                              || nvl(state, 'no state'));
        dbms_output.put_line (' ');
    END LOOP;
END warehouses_report;

BEGIN
    warehouses_report();
END;