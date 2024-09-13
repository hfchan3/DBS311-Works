-- ***********************
-- Names & IDs: Hiu Fung Chan (106184237),
--              Henry Lau (121235238),
--              Trung Kien Phan (123266231)
-- Date:        11 July 2024
-- Purpose:     DBS311 Lab 7 (Group 9)
-- ***********************

-- Question 1 - Create a PL/SQL block to declare a cursor EMP_CUR to select the employee’s name, salary, and hire date from the employee’s table. 
--              Process each row from the cursor, and if the salary is greater than 15,000 and the hire date is greater than 01-FEB-1988, display 
--              the employee’s name, salary, and hire date.

SET SERVEROUTPUT ON

-- Q1 SOLUTION --
DECLARE
    emp_name VARCHAR2(100);
    emp_salary NUMBER;
    emp_hire_date DATE;
    
    CURSOR emp_cur IS
        SELECT first_name || ' ' || last_name AS emp_name, salary, hire_date
        FROM employees_a
        WHERE salary > 15000
        AND hire_date > TO_DATE('01-FEB-1988', 'DD-MON-YYYY');

BEGIN
    OPEN emp_cur;
    
    LOOP
        FETCH emp_cur INTO emp_name, emp_salary, emp_hire_date;
        EXIT WHEN emp_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_name || ', Salary: ' || emp_salary || ', Hire Date: ' || TO_CHAR(emp_hire_date, 'DD-MON-YYYY'));
    END LOOP; 
    
    CLOSE emp_cur;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employees found with the specified criteria.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/

-- Question 2 - Create a PL/SQL block to retrieve the last name and department ID of each employee from the EMPLOYEES table for those employees whose EMPLOYEE_ID is less than 114.
--              From the values retrieved from the employees table, populate two PL/SQL tables, one to store the records of the employee last names and the other to store the records of their department IDs. 
--              Using a loop, retrieve the employee’s name information and the salary information from the PL/SQL tables and display it in the window, using DBMS_OUTPUT.PUT_LINE. Display these details for the 
--              first 15 employees in the PL/SQL tables.

-- Q2 SOLUTION --
SET SERVEROUTPUT ON
DECLARE
    TYPE emp_names_type IS TABLE OF employees_a.last_name%TYPE INDEX BY PLS_INTEGER;
    TYPE dept_ids_type IS TABLE OF employees_a.department_id%TYPE INDEX BY PLS_INTEGER;
    
    emp_last_names emp_names_type;
    emp_dept_ids dept_ids_type;
    
    CURSOR emp_cur IS
        SELECT last_name, department_id
        FROM employees_a
        WHERE employee_id < 114; 
    
    counter PLS_INTEGER := 1;
    
    last_name employees_a.last_name%TYPE;
    department_id employees_a.department_id%TYPE;
BEGIN
    OPEN emp_cur;
    
    LOOP
        FETCH emp_cur INTO last_name, department_id;
        EXIT WHEN emp_cur%NOTFOUND OR counter > 15; 
        
        emp_last_names(counter) := last_name;
        emp_dept_ids(counter) := department_id;
        
        counter := counter + 1;
    END LOOP;
    
    CLOSE emp_cur;
    
    FOR i IN 1..counter-1 LOOP
        DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp_last_names(i) || '; ' || 'Department ID: ' || emp_dept_ids(i));
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employees found with the specified criteria.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/

-- Question 3 - Create a PL/SQL block that declares a cursor called DATE_CUR. Pass a parameter of DATE data type to the cursor and print the details of all the employees who have joined after that date. 
--	  		    SET SERVEROUTPUT ON
--              DEFINE P_HIREDATE = 01-FEB-88

-- Q3 SOLUTION --
SET SERVEROUTPUT ON
DEFINE P_HIREDATE = "01-FEB-88"

DECLARE
   CURSOR DATE_CUR (the_date DATE) IS
   SELECT * FROM employees_a
   WHERE hire_date > the_date
   ORDER BY employee_ID;

BEGIN
    for emp_rec IN DATE_CUR(TO_DATE('&P_HITE_DATE', 'DD-MON-RR')) LOOP
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_rec.employee_id || '; ' || 'Name: ' || emp_rec.first_name || ' ' || emp_rec.last_name || '; ' || 'Hire Date: ' || emp_rec.hire_date);
    END LOOP;
END;
/
    





 
