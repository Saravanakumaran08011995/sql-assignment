-- Given a table named sales with columns order_date, region, and revenue,
-- write a query to calculate the total revenue for each region,
-- ordering the results by region and order date.

Select sum(revenue) over(partition by region)
from sales
order by region, order_date;

-- Using the same sales table, write a query to 
-- find the top 3 highest revenue days for each region.

with ranked_sales as (
	Select * , dense_rank() over(partition by region order by revenue desc) as sales_rank
    from sales
)
Select * 
from ranked_sales
where sales_rank <=3;

-- Suppose you have an employee_salaries table with columns employee_id, salary, and department_id. 
-- Write a query to calculate the average salary for each department, including the department's highest-paid employee's salary.

with department_salaries as (
	Select department_id, max(salary) as highest_salary
    from employee_salaries
    group by department_id
)
Select es.department_id, avg(es.salary), ds.highest_salaries as highest_paid_employee_salary
from employee_salaries es
join department_saleries
on es.department_id = ds.department_id
group by es.department_id, ds.highest_salary;

-- In a table named student_scores with columns student_id,subject, and score,
-- find the student with the highest score in each subject.

Select student_id , subject, max(score) over(partition by subject) as subject
from student_scores;

-- Given a table product_sales with columns product_id, sale_date, and revenue, 
-- calculate the running total revenue for each product, ordered  by sale date.

Select  product_id, sale_date, revenue, sum(revenue) 
from product_sales
group by product_id
order by sale_date;

-- In a table order_details with columns order_id, product_id, and quantity, 
-- find the product that contributed the most to each order in terms of quantity.

with ranked_product as (
	Select order_id, product_id, quantity, rank() over(partition by order_id order by quantity) as product_rank
    from order_details
)
Select order_id, product_id, quantity
from ranked_product
where product_rank = 1 ;


-- Given a table employee_performance with columns employee_id, quarter, performance_score
-- calculate the average performance score for each employee over the last two quarters.

with last_two_quarter as (
	Select employee_id, quarter, performance_score
    from employee_performance
    where str_to_date(quarter, '%b %Y') >= date_sub(now(), interval 6 month)
)
Select employee_id, avg(performance_score)
from last_two_quarter
group by employee_id;

-- Suppose you have a table exam_scores with columns student_id, subject, score, exam_date. 
-- Write a query to find the student who achieved the highest score in each subject within the last month.


With last_month_score as (
	Select student_id, subject, score, exam_date, row_number() over(partition by subject order by score) as mark_rnk
    from exam_scores
    where exam_date >= dateadd(month, -1, getdate())
)
Select *
from last_month_score
where mark_rnk = 1;

-- In a table customer_orders with columns customer_id,order_date, order_total,
-- find the top 10 customers who have spent the most in total across all orders.

Select customer_id, sum(order_total) as total_sum
from customer_orders
group by customer_id
order by total_sum desc
limit 10;

-- Given a table web_traffic with columns page_id, visit_date , page_views
-- find the pages that received the highest number of page views for each month.

with ranked_views as (
	Select page_id, visit_date , page_views, dense_rank() over(partition by date_trunc('month', visit_date) order by page_views desc) as rnk
    from web_traffic
) 
Select * 
from ranked_views
where rnk = 1;

-- Suppose you have a table sales with columns sale_date, product_id, revenue
-- Write a query to calculate the moving average revenue for each product over a 7-day window.

Select sale_date, product_id, revenue , 
avg(revenue) over(partition by product_id order by sale_date rows between 6 preceding and current row) as moving_avg_revenue
from sales
order by product_id, sale_date;

-- In a table student_scores with columns student_id, subject, and score, 
-- find the average score for each subject, and also include the student who scored the highest in each subject.

with highest_score as (
	Select student_id, subject, score, rank() over(partition by subject order by score desc) as high_score
    from student_scores
)
Select hs.student_id, hs.subject, avg(hs.score) as avg_score, hs.high_score
from highest_score hs
where high_score = 1
group by hs.student_id, hs.subject, hs.score;

-- In a table employee_salaries with columns employee_id, salary, department_id
-- find the difference between each employee's salary and the average salary in their department.

Select employee_id, salary, department_id, salary - (
	select avg(es2.salary) 
    from employee_salaries as es2
    where es2.department_id = es1.department_id
) as salary_diff
from employee_salaries es1;

-- Given a table web_logs with columns log_date, user_id, page_views
-- calculate the 7-day rolling average page views for each user.

Select log_date, user_id, page_views, 
avg(page_views) over(partition by user_id order by log_date rows between 6 preceding and current row) as avg_page_views
from web_logs;

-- Suppose you have a table order_details with columns order_id, product_id, unit_price. 
-- Write a query to calculate the total revenue for each order and include the order with the highest revenue in each result row.

with order_revenue as (
	Select order_id, sum(unit_price) as total_revenue
    from order_details
    group by order_id
)
Select od.order_id, od.product_id, od.unit_price, ordr.total_revenue, max(od.unit_price) over(partition by od.order_id) as highest_revenue
from order_details od
join order_revenue ordr 
on od.order_id = ordr.order_id;

-- Given a table product_sales with columns product_id, sale_date, revenue
-- find the products that have had the highest daily revenue at least once.

with daily_revenue as (
	Select product_id, sale_date, sum(revenue) as daily_revenue
    from product_sales
    group by product_id, sale_date
),
max_daily_revenue as (
	Select product_id, max(daily_revenue) as max_daily_revenue
    from daily_revenue
    group by product_id
)
Select distinct product_id
from daily_revenue dr
join max_daily_revenue mdr
on dr.product_id = mdr.product_id
where dr.daily_revenue = mdr.max_daily_revenue

-- In a table employee_performance with columns employee_id, quarter, performance_score
-- find the employees whose performance score has improved for three consecutive quarters.

WITH RankedPerformance AS (
  SELECT
    employee_id,
    quarter,
    performance_score,
    LAG(performance_score) OVER (PARTITION BY employee_id ORDER BY quarter) AS prev_score,
    LAG(quarter, 2) OVER (PARTITION BY employee_id ORDER BY quarter) AS prev_quarter
  FROM
    employee_performance
)

SELECT DISTINCT
  r1.employee_id
FROM
  RankedPerformance r1
JOIN
  RankedPerformance r2 ON r1.employee_id = r2.employee_id
                       AND r1.quarter = r2.prev_quarter
JOIN
  RankedPerformance r3 ON r1.employee_id = r3.employee_id
                       AND r2.quarter = r3.prev_quarter
WHERE
  r1.performance_score > r1.prev_score
  AND r2.performance_score > r2.prev_score
  AND r3.performance_score > r3.prev_score;

-- Given a table product_inventory with columns product_id, transaction_date, and quantity, 
-- calculate the sum of quantities sold for each product over a rolling 30-day period.

SELECT
  product_id,
  transaction_date,
  quantity,
  SUM(quantity) OVER (
    PARTITION BY product_id
    ORDER BY transaction_date
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ) AS rolling_sum
FROM
  product_inventory
ORDER BY
  product_id, transaction_date;

-- Given a table employees with columns employee_id, employee_name, and manager_id,
-- write a SQL query to list all employees and their immediate managers using a CTE.

WITH EmployeeManagerCTE AS (
  SELECT
    e.employee_id AS employee_id,
    e.employee_name AS employee_name,
    e.manager_id AS manager_id,
    m.employee_name AS manager_name
  FROM
    employees e
  LEFT JOIN
    employees m ON e.manager_id = m.employee_id
)

SELECT
  employee_id,
  employee_name,
  manager_id,
  manager_name
FROM
  EmployeeManagerCTE;


-- In a table orders with columns order_id, customer_id, and order_date,
--  write a CTE query to find the number of orders placed by each customer in the year 2022

WITH Orders2022 AS (
  SELECT
    customer_id,
    COUNT(*) AS order_count
  FROM
    orders
  WHERE
    EXTRACT(YEAR FROM order_date) = 2022
  GROUP BY
    customer_id
)

SELECT
  customer_id,
  order_count
FROM
  Orders2022;

-- You have a table product_sales with columns product_id, sale_date, and revenue.
-- Write a CTE query to calculate the cumulative revenue for each product ordered by sale date.

WITH CumulativeRevenueCTE AS (
  SELECT
    product_id,
    sale_date,
    revenue,
    SUM(revenue) OVER (
      PARTITION BY product_id
      ORDER BY sale_date
    ) AS cumulative_revenue
  FROM
    product_sales
)

SELECT
  product_id,
  sale_date,
  revenue,
  cumulative_revenue
FROM
  CumulativeRevenueCTE
ORDER BY
  product_id, sale_date;

-- Given a table student_scores with columns student_id, subject, score, 
-- write a CTE query to find the average score for each subject and display subjects with an average score greater than 80.

WITH SubjectAverageScores AS (
  SELECT
    subject,
    AVG(score) AS average_score
  FROM
    student_scores
  GROUP BY
    subject
)

SELECT
  subject,
  average_score
FROM
  SubjectAverageScores
WHERE
  average_score > 80;

-- In a table employee_salaries with columns employee_id, salary, and department_id, 
-- write a CTE query to find the highest salary in each department.

WITH DepartmentMaxSalary AS (
  SELECT
    department_id,
    MAX(salary) AS max_salary
  FROM
    employee_salaries
  GROUP BY
    department_id
)

SELECT
  es.department_id,
  d.department_name, -- If you have a separate department table
  es.max_salary
FROM
  DepartmentMaxSalary es
JOIN
  departments d ON es.department_id = d.department_id -- Join with department table if available
ORDER BY
  es.department_id;

-- Suppose you have a table orders with columns order_id, customer_id, and order_date. 
-- Write a CTE query to find the first and last order dates for each customer.

WITH CustomerOrderDates AS (
  SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
  FROM
    orders
  GROUP BY
    customer_id
)

SELECT
  customer_id,
  first_order_date,
  last_order_date
FROM
  CustomerOrderDates;

-- Given a table web_logs with columns log_date, user_id, and page_views,
-- write a CTE query to find the users who had the highest daily page views.

WITH DailyMaxPageViews AS (
  SELECT
    log_date,
    MAX(page_views) AS max_page_views
  FROM
    web_logs
  GROUP BY
    log_date
)

SELECT
  w.user_id
FROM
  web_logs w
JOIN
  DailyMaxPageViews d ON w.log_date = d.log_date
                      AND w.page_views = d.max_page_views;

-- In a table product_inventory with columns product_id, transaction_date, and quantity, 
-- write a CTE query to find the products that have never had a negative quantity in stock.

WITH ProductsWithNegativeQuantity AS (
  SELECT DISTINCT
    product_id
  FROM
    product_inventory
  WHERE
    quantity < 0
)

SELECT
  pi.product_id
FROM
  product_inventory pi
WHERE
  pi.product_id NOT IN (SELECT product_id FROM ProductsWithNegativeQuantity);

-- Suppose you have a table expenses with columns expense_id, category, and amount. 
-- Write a CTE query to find the top 5 expense categories with the highest total amount.

WITH CategoryTotalAmount AS (
  SELECT
    category,
    SUM(amount) AS total_amount
  FROM
    expenses
  GROUP BY
    category
)

SELECT
  category,
  total_amount
FROM
  CategoryTotalAmount
ORDER BY
  total_amount DESC
LIMIT 5;

-- Given a table customer_orders with columns customer_id, order_date, and order_total, 
-- write a CTE query to calculate the total ordervalue for each customer and list customers with total order values exceeding $10,000.

WITH CustomerTotalOrderValue AS (
  SELECT
    customer_id,
    SUM(order_total) AS total_order_value
  FROM
    customer_orders
  GROUP BY
    customer_id
)

SELECT
  customer_id,
  total_order_value
FROM
  CustomerTotalOrderValue
WHERE
  total_order_value > 10000;


-- You are given a table sales with columns order_date, region, and revenue. 
-- Write a CTE query to find the total revenue for each region and display regions with total revenue greater than $1,000,000.

WITH RegionTotalRevenue AS (
  SELECT
    region,
    SUM(revenue) AS total_revenue
  FROM
    sales
  GROUP BY
    region
)

SELECT
  region,
  total_revenue
FROM
  RegionTotalRevenue
WHERE
  total_revenue > 1000000;

-- In a table employee_hierarchy with columns employee_id, employee_name, and manager_id, 
-- write a CTE query to find all employees and their immediate managers' names.

WITH EmployeeManagerCTE AS (
  SELECT
    e.employee_id,
    e.employee_name,
    e.manager_id,
    m.employee_name AS manager_name
  FROM
    employee_hierarchy e
  LEFT JOIN
    employee_hierarchy m ON e.manager_id = m.employee_id
)

SELECT
  employee_id,
  employee_name,
  manager_name
FROM
  EmployeeManagerCTE;


-- Given a table product_sales with columns product_id, sale_date, and revenue, 
-- write a CTE query to calculate the average revenue for each product for the last 3 months.

WITH Last3MonthsSales AS (
  SELECT
    product_id,
    AVG(revenue) AS average_revenue
  FROM
    product_sales
  WHERE
    sale_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
  GROUP BY
    product_id
)

SELECT
  product_id,
  average_revenue
FROM
  Last3MonthsSales;

-- You have a table order_details with columns order_id,
-- product_id, and quantity. Write a CTE query to find the total quantity
-- ordered for each product and rank the products by total quantity.

WITH ProductTotalQuantity AS (
  SELECT
    product_id,
    SUM(quantity) AS total_quantity
  FROM
    order_details
  GROUP BY
    product_id
)

SELECT
  product_id,
  total_quantity,
  RANK() OVER (ORDER BY total_quantity DESC) AS quantity_rank
FROM
  ProductTotalQuantity
ORDER BY
  total_quantity DESC;

-- In a table employee_salaries with columns employee_id, salary,
-- and department_id, write a CTE query to find the employees who have the
-- same salary as their department's average salary.

WITH DepartmentAverageSalaries AS (
  SELECT
    department_id,
    AVG(salary) AS avg_salary
  FROM
    employee_salaries
  GROUP BY
    department_id
)

SELECT
  e.employee_id,
  e.salary,
  e.department_id
FROM
  employee_salaries e
JOIN
  DepartmentAverageSalaries d ON e.department_id = d.department_id
                             AND e.salary = d.avg_salary;


-- Given a table web_logs with columns log_date, user_id, and
-- page_views, write a CTE query to find the date with the highest total page
-- views and the user who had the highest page views on that date.

WITH DailyPageViews AS (
  SELECT
    log_date,
    SUM(page_views) AS total_page_views
  FROM
    web_logs
  GROUP BY
    log_date
),
MaxPageViews AS (
  SELECT
    MAX(total_page_views) AS max_page_views
  FROM
    DailyPageViews
)

SELECT
  dp.log_date,
  w.user_id
FROM
  DailyPageViews dp
JOIN
  web_logs w ON dp.log_date = w.log_date
JOIN
  MaxPageViews mp ON dp.total_page_views = mp.max_page_views
ORDER BY
  dp.log_date
LIMIT 1;

-- Suppose you have a table expenses with columns expense_id,
-- category, and amount. Write a CTE query to find the category with the
-- highest total amount spent and list expenses within that category.

WITH CategoryTotalAmount AS (
  SELECT
    category,
    SUM(amount) AS total_amount
  FROM
    expenses
  GROUP BY
    category
)

SELECT
  e.expense_id,
  e.category,
  e.amount
FROM
  expenses e
JOIN (
  SELECT
    category,
    RANK() OVER (ORDER BY total_amount DESC) AS category_rank
  FROM
    CategoryTotalAmount
  LIMIT 1
) cte ON e.category = cte.category
ORDER BY
  e.amount DESC;

-- Given a table customer_orders with columns customer_id,
-- order_date, and order_total, write a CTE query to find the customers who
-- placed orders on the same date as the highest total daily order value.

WITH DailyOrderTotals AS (
  SELECT
    order_date,
    SUM(order_total) AS total_daily_order_value
  FROM
    customer_orders
  GROUP BY
    order_date
),

MaxDailyOrderTotal AS (
  SELECT
    MAX(total_daily_order_value) AS max_daily_order_value
  FROM
    DailyOrderTotals
)

SELECT
  co.customer_id,
  co.order_date,
  co.order_total
FROM
  customer_orders co
JOIN
  DailyOrderTotals dot ON co.order_date = dot.order_date
JOIN
  MaxDailyOrderTotal mdot ON dot.total_daily_order_value = mdot.max_daily_order_value;

-- In a table product_inventory with columns product_id,
-- transaction_date, and quantity, write a CTE query to find the products that
-- have the highest cumulative quantity purchased in the last 90 days.

WITH CumulativeQuantityLast90Days AS (
  SELECT
    product_id,
    SUM(quantity) OVER (
      PARTITION BY product_id
      ORDER BY transaction_date
      ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
    ) AS cumulative_quantity_last_90_days
  FROM
    product_inventory
)

SELECT
  product_id,
  cumulative_quantity_last_90_days
FROM
  CumulativeQuantityLast90Days
WHERE
  cumulative_quantity_last_90_days = (
    SELECT
      MAX(cumulative_quantity_last_90_days)
    FROM
      CumulativeQuantityLast90Days
  );


-- Suppose you have a table employee_performance with columns
-- employee_id, quarter, and performance_score. Write a CTE query to find
-- the employees who have shown consistent improvement in their
-- performance score over the last four quarters.

WITH PerformanceChanges AS (
  SELECT
    employee_id,
    quarter,
    performance_score,
    LAG(performance_score) OVER (PARTITION BY employee_id ORDER BY quarter) AS prev_score,
    LAG(performance_score, 2) OVER (PARTITION BY employee_id ORDER BY quarter) AS prev_score_2,
    LAG(performance_score, 3) OVER (PARTITION BY employee_id ORDER BY quarter) AS prev_score_3
  FROM
    employee_performance
)

SELECT DISTINCT
  pc.employee_id
FROM
  PerformanceChanges pc
WHERE
  pc.performance_score > pc.prev_score
  AND pc.prev_score > pc.prev_score_2
  AND pc.prev_score_2 > pc.prev_score_3;

-- You are designing a database for a library. Create a view that
-- lists all books available for checkout along with their authors' names.
-- Explain the benefits of using this view.

CREATE VIEW AvailableBooks AS
SELECT
  b.book_id,
  b.title AS book_title,
  a.author_id,
  CONCAT(a.first_name, ' ', a.last_name) AS author_name
FROM
  books b
JOIN
  book_authors ba ON b.book_id = ba.book_id
JOIN
  authors a ON ba.author_id = a.author_id
WHERE
  b.available_for_checkout = true;

-- Benefits of Using this View:

-- Simplified Access: Users, such as librarians or patrons, can easily access a list of available books and their authors 
-- without needing to write complex SQL queries each time.

-- Consistency: Since views provide a predefined, consistent query of the data, it helps ensure that everyone accessing the library's database
--  gets the same information, reducing the chances of errors or discrepancies.

-- Abstraction: The view abstracts the underlying data structure, making it easier to understand and use, 
-- especially for users who may not be familiar with the database schema.

-- Security: You can control access to the view, allowing you to restrict certain users or roles from seeing sensitive data or columns 
-- in the underlying tables.

-- Performance: Depending on the complexity of your database queries, using a view can sometimes improve query performance
--  by simplifying the underlying query and optimizing it.

-- Convenience: Users can query this view directly when searching for available books, which can save them time and effort.



-- You have a table sales_data with columns order_date, region,
-- salesperson_id, and revenue. Write an SQL query to find the
-- top-performing salesperson in each region based on the highest total
-- revenue. Use a combination of CTEs and window functions.

WITH SalespersonTotalRevenue AS (
  SELECT
    region,
    salesperson_id,
    SUM(revenue) AS total_revenue,
    RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC) AS rank_in_region
  FROM
    sales_data
  GROUP BY
    region,
    salesperson_id
)

SELECT
  region,
  salesperson_id,
  total_revenue
FROM
  SalespersonTotalRevenue
WHERE
  rank_in_region = 1;

-- Given a table employee_salaries with columns employee_id,
-- salary, and department_id, write an SQL query to find the department with
-- the highest average salary. Additionally, list the employees within that
-- department who have a salary greater than the department's average
-- salary.

WITH DepartmentAverageSalaries AS (
  SELECT
    department_id,
    AVG(salary) AS avg_salary
  FROM
    employee_salaries
  GROUP BY
    department_id
),

HighestAvgSalaryDepartment AS (
  SELECT
    department_id
  FROM
    DepartmentAverageSalaries
  ORDER BY
    avg_salary DESC
  LIMIT 1
)

SELECT
  es.employee_id,
  es.salary,
  es.department_id
FROM
  employee_salaries es
JOIN
  HighestAvgSalaryDepartment had ON es.department_id = had.department_id
WHERE
  es.salary > (SELECT avg_salary FROM DepartmentAverageSalaries WHERE department_id = es.department_id);

-- You are given a table customer_orders with columns
-- customer_id, order_date, and order_total. Write an SQL query to find the
-- top 3 customers who have placed the most orders, along with the total
-- number of orders placed by each of them.

SELECT
  customer_id,
  COUNT(order_id) AS total_orders
FROM
  customer_orders
GROUP BY
  customer_id
ORDER BY
  total_orders DESC
LIMIT 3;

-- In a table product_inventory with columns product_id,
-- transaction_date, and quantity, write an SQL query to find the products with
-- the highest and lowest average quantity sold per month. Use CTEs and
-- window functions.

WITH MonthlyAverageQuantity AS (
  SELECT
    product_id,
    EXTRACT(YEAR FROM transaction_date) AS year,
    EXTRACT(MONTH FROM transaction_date) AS month,
    AVG(quantity) AS avg_quantity_per_month,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date) ORDER BY AVG(quantity) DESC) AS rank_highest,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date) ORDER BY AVG(quantity) ASC) AS rank_lowest
  FROM
    product_inventory
  GROUP BY
    product_id, year, month
)

SELECT
  product_id,
  year,
  month,
  avg_quantity_per_month
FROM
  MonthlyAverageQuantity
WHERE
  rank_highest = 1
  OR rank_lowest = 1;


-- Given a table web_logs with columns log_date, user_id, and
-- page_views, write an SQL query to find the date with the highest total page
-- views and the user who had the highest page views on that date.
-- Additionally, provide the total page views on that date.

WITH DailyPageViews AS (
  SELECT
    log_date,
    SUM(page_views) AS total_page_views,
    MAX(page_views) AS max_page_views
  FROM
    web_logs
  GROUP BY
    log_date
)

SELECT
  dp.log_date,
  u.user_id,
  dp.max_page_views AS highest_page_views,
  dp.total_page_views AS total_page_views_on_date
FROM
  DailyPageViews dp
JOIN (
  SELECT
    log_date,
    user_id
  FROM
    web_logs
  WHERE
    page_views = (SELECT MAX(max_page_views) FROM DailyPageViews)
  LIMIT 1
) u ON dp.log_date = u.log_date;
