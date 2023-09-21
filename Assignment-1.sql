-- Create Database as SQL practice and use it for further questions.

Create database Sql_Practice;

show databases;

use Sql_Practice;

select database();

/*Create a table named "Students" with the following columns:
StudentID (int), FirstName (varchar), LastName (varchar), and Age (int). 
Insert at least three records into the table.*/

Create table Students (
	StudentId int,
    FirstName varchar(50),
    LastName varchar(50),
    Age int
);

show tables;

Insert into Students(StudentId,Firstname,LastName,Age)
values(1,"Saravana","Kumaran",28),
	  (2,"Mohan","Kumar",22),
      (3,"Jeya","Vignesh",26),
      (4,"Nithish","Kumar",24),
      (5,"Alan","Babu",25);
      
Select * from Students;

-- Update the age of the student with StudentID 1 to 21. Delete the student with StudentID 3 from the "Students" table.

set sql_safe_updates = 0;
update Students set age = 21 where StudentId = 1;

Delete from Students where StudentId = 3;

-- Retrieve the first names and ages of all students who are older than 20.

Select firstname,age from students
where age>20;

-- Delete records from the same table where age<18.

Delete from Students where age < 18;

/*Create a table named "Customers" with the following columns and constraints: 
CustomerID (int) as the primary key. 
FirstName (varchar) not null.
LastName (varchar) not null. 
Email (varchar) unique. 
Age (int) check constraint to ensure age is greater than 18.*/

Create table Customers (
	CustomerID int primary key,
    FirstName varchar(50) not null,
    Lastname  varchar(50) not null,
    Email varchar(100) unique,
    Age int check( age > 18)
);

describe customers;

/*You have a table named "Orders" with columns:
OrderID (int), CustomerID (int), OrderDate (date), and TotalAmount (decimal).
Create a foreign key constraint on the "CustomerID" column referencing the "Customers" table.*/

Create table Orders (
	OrderID int,
    CustomerID int , foreign key(CustomerID) references Customers(CustomerID),
    OrderDate date,
    TotalAmount decimal
);

Describe Orders;

/*
Create a table named "Employees" with columns: 
EmployeeID (int) as the primary key. FirstName (varchar) not null. 
LastName (varchar) not null. 
Salary (decimal) check constraint to ensure salary is between 20000 and 100000.
*/

Create table Employees (
	EmployeeID int primary key,
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    Salary decimal check( salary between 20000 and 100000)
);

desc Employees;

/*
Create a table named "Books" with columns: 
BookID (int) as the primary key. 
Title (varchar) not null. 
ISBN (varchar) unique.
*/

Create table Books (
	BookID int primary key,
    Title varchar(50) not null,
    ISBN varchar(50) unique
);

desc Books;

/*Consider a table named "Employees" with columns: EmployeeID, FirstName, LastName, and Age.
Write an SQL query to retrieve the first name and last name of employees who are older than 30.*/

Select FirstName, LastName from employees
where age > 30;

/*
Using the same "Employees" table, 
write an SQL query to retrieve the first name, last name, and age of employees whose age is between 20 and 30.
*/

Select Firstname, LastName from employees
where age between 20 and 30;

/*
Given a table named "Products" with columns: ProductID, ProductName, Price, and InStock (0- for out of stock, 1- for in stock).
Write an SQL query to retrieve the product names and prices of products that are either priced above $100 or are out of stock.
*/

Select ProductName, Price from Products
where Price > 100 or InStock = 0;

/*
Using the "Products" table, 
write an SQL query to retrieve the product names and prices of products that are in stock and priced between 50 and 150.
*/
Select ProductName, Price from Products
where InStock = 1 and price between 50 and 150;

/*
Consider a table named "Orders" with columns: OrderID, OrderDate, TotalAmount, and CustomerID.
Write an SQL query to retrieve the order IDs and total amounts of orders placed by customer ID 1001 after January 1, 2023, 
or orders with a total amount exceeding $500
*/

Select OrderID, TotalAmount from Orders
where (CustomerID = 1001 and OrderDate > '2023-01-01') or TotalAmount > 500;


-- Retrieve the ProductName of products from the "Products" table that have a price between $50 and $100.

Select ProductName from products
where price between 50 and 100;

/*
Retrieve the names of employees from the "Employees" table who are both from the "Sales" department and have an age greater than 25,
 or they are from the "Marketing" department.
*/

Select FirstName, LastName from employees
where (department = "Sales" and age >25) or department = "Marketing";

-- Retrieve the names of customers from the "Customers" table who are not from the city 'New York' or 'Los Angeles'.

Select FirstName, LastName from Customers where not city = "New York";

/*
Retrieve the names of employees from the "Employees" table who are either from the "HR" department and have an age less than 30,
or they are from the "Finance" department and have an age greater than or equal to 35.
*/

Select FirstName, LastName from employees
where (department = "HR" and age < 30) or (department = "Finance" and age >= 35);

/*
Retrieve the names of customers from the "Customers" table who are not from the city 'London' and either have a postal code starting with '1' 
or their country is not 'USA'.
*/

Select FirstName, LastName
from Customers
where not city = 'London' and (postal_code LIKE '1%' OR country != 'USA');
