CREATE TABLE Employees (
    EMPLOYEE_ID int primary key,
    FIRST_NAME varchar(50),
    LAST_NAME varchar(50),
    EMAIL varchar(100),
    PHONE_NUMBER varchar(20),
    HIRE_DATE DATE,
    JOB_ID int,
    SALARY decimal(10, 2), -- Change the precision and scale as needed
    COMMISSION_PCT decimal(5, 2), -- Change the precision and scale as needed
    MANAGER_ID int,
    DEPARTMENT_ID int
);

INSERT INTO Employees (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES
  (1, 'John', 'Doe', 'johndoe@example.com', '555-123-4567', '2023-09-07', 1, 60000.00, 0.10, NULL, 1),
  (2, 'Jane', 'Smith', 'janesmith@example.com', '555-234-5678', '2023-09-07', 2, 40000.00, 0.05, 1, 1),
  (3, 'Bob', 'Johnson', 'bobjohnson@example.com', '555-345-6789', '2023-09-07', 2, 40000.00, 0.05, 1, 1),
  (4, 'Alice', 'Brown', 'alicebrown@example.com', '555-456-7890', '2023-09-07', 3, 55000.00, 0.08, 2, 2),
  (5, 'Eva', 'Wilson', 'evawilson@example.com', '555-567-8901', '2023-09-08', 3, 52000.00, 0.08, 2, 2);


INSERT INTO Employees (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES
  (6, 'Michael', 'Adams', 'michaeladams@example.com', '555-678-9012', '2023-09-08', 4, 62000.00, 0.12, 3, 2),
  (7, 'Sara', 'Davis', 'saradavis@example.com', '555-789-0123', '2023-09-08', 4, 63000.00, 0.12, 3, 2),
  (8, 'Tom', 'Smith', 'tomsmith@example.com', '555-890-1234', '2023-09-09', 5, 72000.00, 0.15, 1, 3),
  (9, 'Olivia', 'Martinez', 'oliviamartinez@example.com', '555-901-2345', '2023-09-09', 5, 71000.00, 0.15, 1, 3),
  (10, 'David', 'Lee', 'davidlee@example.com', '555-012-3456', '2023-09-09', 6, 80000.00, 0.18, 4, 3);

-- Create the Department table
CREATE TABLE Department (
    DEPARTMENT_ID int primary key,
    DEPARTMENT_NAME varchar(100),
    MANAGER_ID int,
    LOCATION_ID int,
    foreign key (MANAGER_ID) REFERENCES Employees (EMPLOYEE_ID)
);

INSERT INTO Department (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES
  (1, 'HR', 1, 1),
  (2, 'Sales', 2, 2),
  (3, 'Finance', 3, 3),
  (4, 'Marketing', 4, 4),
  (5, 'IT', 5, 5);
  
  
-- Write a SQL query to find those employees who receive a higher salary than the
-- employee with ID 3. Return first name, last name.

Select first_name, last_name 
from employees
where salary > ( select salary 
				 from employees
                 where employee_id = 3);

-- write a SQL query to find out which employees have the same designation as the
-- employee whose ID is 3. Return first name, last name, department ID and job ID.


SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID, JOB_ID
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID 
				FROM EMPLOYEES
                WHERE EMPLOYEE_ID = 3);


-- Write a SQL query to find those employees whose salary matches the lowest salary
-- of any of the departments. Return first name, last name and department ID.

SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY IN (SELECT MIN(SALARY) 
				 FROM EMPLOYEES
                 GROUP BY DEPARTMENT_ID);

-- write a SQL query to find those employees who report to that manager whose first
-- name is ‘Jane’. Return first name, last name, employee ID and salary.

SELECT FIRST_NAME, LAST_NAME, EMPLOYEE_ID, SALARY
FROM EMPLOYEES 
WHERE MANAGER_ID = ( SELECT MANAGER_ID 
					 FROM EMPLOYEES
                     WHERE FIRST_NAME = "Jane");
                     

-- write a SQL query to find those employees whose ID matches any of the numbers
-- 2, 4 and 6. Return all the fields.

SELECT *
FROM Employees
WHERE EMPLOYEE_ID IN (2, 4, 6);

-- write a SQL query to find those employees whose salary is in the range of 40000,
-- and 60000 (Begin and end values have included.). Return all the fields.

SELECT *
FROM EMPLOYEES
WHERE SALARY BETWEEN 40000 AND 60000;

-- write a SQL query to find those employees whose salary falls within the range of the
-- smallest salary and 55000. Return all the fields.

SELECT * 
FROM EMPLOYEES
WHERE SALARY BETWEEN (SELECT MIN(SALARY) FROM EMPLOYEES) AND 55000;

-- write a SQL query to find those employees who do not work in the departments
-- where managers’ IDs are between 1 and 3 (Begin and end values are included.).
-- Return all the fields of the employees.


SELECT *
FROM Employees
WHERE DEPARTMENT_ID NOT IN (
    SELECT DEPARTMENT_ID
    FROM Employees
    WHERE MANAGER_ID BETWEEN 1 AND 3
);

-- write a SQL query to find those employees who work in the same department as
-- ‘Sara’. Exclude all those records where the first name is ‘Sara’. Return first name, last
-- name and hire date.

SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
					   FROM EMPLOYEES
                       WHERE FIRST_NAME = "Sara") AND FIRST_NAME != "Sara";
                       

-- write a SQL query to find those employees who work in a department where the
-- employee’s first name contains the letter 'T'. Return employee ID, first name and last name.

SELECT FIRST_NAME, LAST_NAME, EMPLOYEE_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID 
						FROM EMPLOYEES
                        WHERE FIRST_NAME LIKE "%T%");

-- write a SQL query to find those employees who earn more than the average salary
-- and work in the same department as an employee whose first name contains the letter
-- 'J'. Return employee ID, first name and salary.

SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) AND DEPARTMENT_ID IN ( SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME LIKE "%j%");


CREATE TABLE Location (
    LOCATION_ID INT PRIMARY KEY,
    LOCATION_NAME VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    COUNTRY VARCHAR(50)
);

-- Sample data for the Location table
INSERT INTO Location (LOCATION_ID, LOCATION_NAME, CITY, STATE, COUNTRY)
VALUES
  (1, 'Head Office', 'New York', 'NY', 'USA'),
  (2, 'Sales Office', 'Los Angeles', 'CA', 'USA'),
  (3, 'Finance Office', 'Chicago', 'IL', 'USA'),
  (4, 'Marketing Office', 'San Francisco', 'CA', 'USA'),
  (5, 'IT Office', 'Seattle', 'WA', 'USA');
  
ALTER TABLE Department
ADD CONSTRAINT FK_Department_Location
FOREIGN KEY (LOCATION_ID)
REFERENCES Location(LOCATION_ID);

-- write a SQL query to find those employees whose department is located at
-- ‘New York’. Return first name, last name, employee ID, job ID.

SELECT E.FIRST_NAME, E.LAST_NAME, E.EMPLOYEE_ID, E.JOB_ID
FROM EMPLOYEES E
INNER JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCATION_ID
WHERE L.CITY = "New York";

-- write a SQL query to find those employees whose salaries are higher than the
-- average for all departments. Return employee ID, first name, last name, job ID.

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);

-- Write a query to display the employee id, name ( first name and last name ) and the
-- job id column with a modified title SALESMAN for those employees whose job title is
-- ST_MAN and DEVELOPER for whose job title is IT_PROG.

SELECT EMPLOYEE_ID , CONCAT(FIRST_NAME, " ", LAST_NAME) AS NAME,
	CASE 
		WHEN JOB_ID = "ST_MAN" THEN 'SALESMAN'
        WHEN JOB_ID = "IT_PROG" THEN 'DEVELOPER'
        ELSE JOB_ID
	END AS JOB_TITLE	
FROM EMPLOYEES;

-- Write a query to display the employee id, name ( first name and last name ), salary
-- and the SalaryStatus column with a title HIGH and LOW respectively for those
-- employees whose salary is more than and less than the average salary of all  employees.

SELECT EMPLOYEE_ID , CONCAT(FIRST_NAME, " ", LAST_NAME), SALARY,
	CASE 
		WHEN SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) THEN "HIGH"
		ELSE "LOW"
    END AS SALARY_STATUS
FROM EMPLOYEES;

-- write a SQL query to find those employees whose salaries exceed 50% of their
-- department's total salary bill. Return first name, last name.

SELECT E.FIRST_NAME, E.LAST_NAME
FROM Employees E
WHERE E.SALARY > 0.5 * (
    SELECT SUM(S.SALARY)
    FROM Employees S
    WHERE S.DEPARTMENT_ID = E.DEPARTMENT_ID
);

-- write a SQL query to find those employees who are managers. Return all the fields of the employees table.
SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (SELECT DISTINCT(MANAGER_ID) FROM EMPLOYEES);

-- Find duplicate values in 1 column

SELECT MANAGER_ID, COUNT(*) as duplicate_count
FROM EMPLOYEES
GROUP BY MANAGER_ID
HAVING COUNT(*) > 1;


-- Find duplicate values on 2 columns combination

SELECT MANAGER_ID, DEPARTMENT_ID , COUNT(*) AS DUPLICATE_COUNT
FROM EMPLOYEES
GROUP BY MANAGER_ID, DEPARTMENT_ID
HAVING COUNT(*) > 1;

-- Write a SQL query to find the most frequent value in a column, along with its frequency.

SELECT DEPARTMENT_ID, COUNT(DEPARTMENT_ID) AS FREQUENCY
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY FREQUENCY DESC
LIMIT 1;

-- Write a SQL query to find the names of all employees who earn more than
-- the average salary in their department using a correlated subquery.

SELECT CONCAT(FIRST_NAME," ",LAST_NAME) AS NAME
FROM EMPLOYEES E
WHERE SALARY > ( SELECT AVG(SALARY)
				 FROM EMPLOYEES F
                 WHERE F.DEPARTMENT_ID = E.DEPARTMENT_ID);
                 

-- Write a SQL query to find the total number of orders placed by each customer,
-- including customers who haven't placed any orders, using a correlated subquery.

SELECT customer_id, customer_name,
(SELECT COUNT(*)
FROM orders
WHERE customer_id = c.customer_id) as order_count
FROM customers c;

-- Create a SQL query to find the employees who have salaries greater than their
-- immediate manager using a correlated subquery.

SELECT e.FIRST_NAME
FROM employees e
WHERE salary > (
SELECT salary
FROM employees
WHERE employee_id = e.manager_id
);
