-- How can you select all employees whose names start with the letter 'A'?

Select * from employees where firstname like "A%"; 

-- How do you find all products whose names contain the word 'phone' regardless of case?

Select * from products where lower(product_name) like "%phone%";

-- How can you retrieve all email addresses from a table that end with '.com'?

Select email_address from employees where email_address like "%.com";

-- How do you find all phone numbers that start with the area code '555'?

Select phone_number from employees where area_code like "555%";


-- How can you select all cities that start with 'New' followed by any characters?

Select cities from employees where cities like "New%";

-- How do you find all records where the value in the 'description' column contains either 'apple' or 'orange'?

Select * from products where description regexp "apple|orange";

-- How can you retrieve all email addresses that follow the pattern of "user@domain.com"?

Select email_address from employees where email_address like "%@%.com";

-- How do you find all records where the 'product_code' is exactly four characters long and consists of letters and digits?

Select * from products where product_code regexp "^[A-Za-z0-9]{4}$";

-- How can you retrieve all phone numbers that match the pattern '###-###-####'?

Select phone_number from employees where phone_number regexp "^[0-9]{3}-[0-9]{3}-[0-9]{4}$";

-- How do you find all records where the 'text' column contains two consecutive digits?

Select * from products where text_desc regexp "[0-9]{2}";

-- Find all employees whose birthdates are not recorded (NULL).

Select first_name from employees where birth_date is null;

-- List all orders that don't have a customer assigned (NULL customerID).

Select * from orders where customer_ID is null;

-- Find the total quantity sold for each product.

Select product, Quantity from sales;

-- Calculate the total revenue generated from each product (Total Revenue = Quantity * Price).

Select product, (Quantity * Price) as Total_Revenue from sales; 

-- Determine the average price of each product.

Select product, avg(price) as Avg_price from sales
group by product;

-- Find the product with the highest total revenue (Quantity * Price)

Select product, (Quantity * Price) as total_revenue from sales 
order by total_revenue desc limit 1;

-- Calculate the total quantity sold across all products.,
Select sum(Quantity) as Total_sales from sales;

-- Determine the average price of all products.
Select round(avg(price)) as average from sales;

-- Determine the square root of the price for each product.

Select productName, sqrt(price) as square_price from products;

-- Find the ceiling (smallest integer greater than or equal to) of the prices.

Select productName, price, ceil(price) from products;

-- Calculate the floor (largest integer less than or equal to) of the prices.

Select productName, price, floor(price) from products;

Create table orders (
	orderID int auto_increment primary key,
    orderDate datetime,
    deliveryDate datetime
);

INSERT INTO orders (orderDate, deliveryDate)
VALUES
    ('2023-09-06 08:00:00', '2023-09-10 14:30:00'),
    ('2023-09-07 10:15:00', '2023-09-11 13:45:00'),
    ('2023-09-08 14:30:00', '2023-09-12 10:00:00'),
    ('2023-09-09 09:45:00', '2023-09-13 11:30:00'),
    ('2023-09-10 11:30:00', '2023-09-14 15:15:00');

-- Find the difference in days between the order date and delivery date for each order.

Select * ,abs(datediff(orderDate, deliveryDate)) as date_difference from orders;

-- Calculate the total delivery time in hours for all orders.

Select sum(timestampdiff(hour, orderDate, deliveryDate)) as total_hour_time from orders;

-- Determine the day of the week when each order was placed.

Select dayname(orderDate) as order_day, orderDate from orders;

-- Find the orders that were placed on a Saturday (DayOfWeek = 7).

Select * from orders where dayofweek(orderDate) = 7;

-- Calculate the average delivery time in days for all orders.

Select abs(avg(datediff(orderDate, deliveryDate))) as avg_delivery from orders;

-- Find the orders that were delivered on the same day they were placed.

Select * from orders where date(orderDate) = date(deliveryDate);

-- Write an SQL query to find the customer IDs of customers who have placed orders with a total amount greater than $1,000.

Select customerID from orders where total_amount > 1000;

-- Write an SQL query to find the product IDs of products that have been sold in quantities
-- greater than 100 on at least three different sale dates.

SELECT ProductID
FROM sales
GROUP BY ProductID
HAVING COUNT(DISTINCT SaleDate) >= 3
   AND SUM(QuantitySold) > 100;

-- Write an SQL query to find the average salary of employees in each department, but
-- only for departments where the average salary is greater than $60,000.

SELECT Department, AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY Department
HAVING AVG(Salary) > 60000;

-- Write an SQL query to find the course names in which the average score of all students
-- is greater than or equal to 80.
-- StudentID, Course, Score

Select course from students
group by course
having avg(score) >=80;

-- Consider a table named Employees with the following columns:
-- EmployeeID (integer): The unique identifier for each employee.
-- Department (string): The department in which the employee works.
-- Salary (decimal): The salary of the employee.
-- Write an SQL query to find the department with the highest average salary.

Select department, avg(salary) as avg_sal 
from employees
group by department
order by avg_sal desc
limit 1;

-- Consider a table named Sales with the following columns:
-- ProductID (integer): The unique identifier for each product.
-- SaleDate (date): The date of the sale.
-- QuantitySold (integer): The quantity of the product sold on that date
-- Write an SQL query to find the product with the highest total quantity sold.

Select productId
from Sales
group by ProductId
order by sum(QuantitySold) desc
limit 1;

-- Consider a table named Students with the following columns:
-- StudentID (integer): The unique identifier for each student.
-- Course (string): The course name.
-- Score (integer): The score obtained by the student in the course.
-- Write an SQL query to find the top three students with the highest average score across all courses.

Select StudentID, avg(Score) as avg_score
from students
group by StudentID
order by avg_score desc
limit 3;

-- Consider a table named Orders with the following columns:
-- OrderID (integer): The unique identifier for each order.
-- CustomerID (integer): The unique identifier for each customer.
-- OrderDate (date): The date of the order.
-- TotalAmount (decimal): The total amount of the order.
-- Write an SQL query to find the total amount of orders placed by each customer, ordered in descending order of total amount.

Select customerID, sum(totalAmount) as Total_order_amount
from orders
group by customerID
order by Total_order_amount desc;


-- Consider a table named Books with the following columns:
-- BookID (integer): The unique identifier for each book.
-- Author (string): The author of the book.
-- PublicationYear (integer): The year the book was published.
-- Write an SQL query to find the number of books published by each author in descending order of the count.

Select Author, count(bookID) as total_books
from books
group by author
order by total_books desc;


-- Consider a table named Orders with the following columns:
-- OrderID (integer): The unique identifier for each order.
-- CustomerID (integer): The unique identifier for each customer.
-- OrderDate (date): The date of the order.
-- TotalAmount (decimal): The total amount of the order.
-- Write an SQL query to find the customer IDs of customers who have placed orders with
-- a total amount greater than $1,000 and have placed at least two orders.

Select customerId
from orders
group by customerId
having sum(Total_Amount) > 1000 and count(orderID)>1;

-- Consider a table named Products with the following columns:
-- ProductID (integer): The unique identifier for each product.
-- Category (string): The category of the product.
-- Price (decimal): The price of the product.
-- Write an SQL query to find the average price of products in each category, ordered by  category name in ascending order.

Select Category, avg(price) as avg_price
from products
group by Category
order by avg_price;

-- Consider a table named Employees with the following columns:
-- EmployeeID (integer): The unique identifier for each employee.
-- Department (string): The department in which the employee works.
-- Salary (decimal): The salary of the employee.
-- Write an SQL query to find the department(s) with the lowest average salary.

Select department, avg(salary) as avg_salary
from employees
group by department
having avg(salary) = (
	Select min(salary)
    from (
		Select avg(salary)
        from employees
        group by department
    )
);

-- Consider a table named Orders with the following columns:
-- OrderID (integer): The unique identifier for each order.
-- CustomerID (integer): The unique identifier for each customer.
-- OrderDate (date): The date of the order.
-- TotalAmount (decimal): The total amount of the order.
-- Write an SQL query to find the customer IDs of customers who have placed orders with
-- a total amount greater than $500 in the year 2023, ordered by customer ID in ascending
-- order.

Select CustomerID
from (Select CustomerID, sum(total_amount) as amount
	from Orders
    where year(orderDate) = 2023
    group by customerID
    having sum(total_amount) > 500
)
order by customerID;

-- Consider a table named Students with the following columns:
-- StudentID (integer): The unique identifier for each student.
-- Course (string): The course name.
-- Score (integer): The score obtained by the student in the course.
-- Write an SQL query to find the course names in which the highest score achieved by
-- any student is greater than or equal to 90, ordered by course name in ascending order.

Select Course 
from students
group by Course
having max(Score) >= 90
order by Course;

-- Consider a table named Orders with the following columns:
-- OrderID (integer): The unique identifier for each order.
-- CustomerID (integer): The unique identifier for each customer.
-- OrderDate (date): The date of the order.
-- TotalAmount (decimal): The total amount of the order.
-- Write an SQL query to find the customer IDs of customers who have placed orders with
-- a total amount greater than $500 in the year 2023 and have placed at least two orders
-- in that year.

SELECT CustomerID
FROM Orders
WHERE YEAR(OrderDate) = 2023
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 500 AND COUNT(OrderID) >= 2;

-- Consider a table named Students with the following columns:
-- StudentID (integer): The unique identifier for each student.
-- Course (string): The course name.
-- Score (integer): The score obtained by the student in the course.
-- Write an SQL query to find the course names where the average score of students who
-- scored less than 70 in at least one course is greater than or equal to 80.

Select course, avg(score) as avg_score
from students
group by course
having avg(case when Score < 70 Then 1 ELSE 0 END) = 0 and avg(Score) >= 80;

-- Consider a table named Employees with the following columns:
-- EmployeeID (integer): The unique identifier for each employee.
-- Department (string): The department in which the employee works.
-- Salary (decimal): The salary of the employee.
-- Write an SQL query to find the departments where the highest salary is greater than
-- $80,000 and the total number of employees in that department is at least 5.

Select department
from employees
group by department
having max(salary) > 80000 and count(employeeID) > 4;


-- Consider a table named Products with the following columns:
-- ProductID (integer): The unique identifier for each product.
-- Category (string): The category of the product.
-- Price (decimal): The price of the product.
-- Write an SQL query to find the categories where the average price of products is
-- greater than or equal to $50, and the maximum price within that category is greater than
-- $100.

Select category
from products
group by category
having avg(price) >= 50 and max(price) = 100;

-- Consider a table named Orders with the following columns:
-- OrderID (integer): The unique identifier for each order.
-- CustomerID (integer): The unique identifier for each customer.
-- OrderDate (date): The date of the order.
-- TotalAmount (decimal): The total amount of the order.
-- Write an SQL query to find the customer IDs of customers who have placed orders with
-- a total amount greater than $1,000 in any single order and have placed orders on at
-- least three different dates.

Select CustomerID
from orders
group by CustomerID 
having count(distinct(orderDate))>=3 and sum(total_amount > 1000) >= 1;








		



