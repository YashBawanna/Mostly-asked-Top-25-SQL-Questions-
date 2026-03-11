Create Database Maang;

CREATE TABLE employees (
id INT,
name VARCHAR(50),
department VARCHAR(50),
salary INT,
email VARCHAR(100)
);

INSERT INTO employees VALUES
(1,'John','IT',70000,'john@company.com'),
(2,'Sarah','HR',60000,'sarah@company.com'),
(3,'Mike','IT',90000,'mike@company.com'),
(4,'Emma','Finance',75000,'emma@company.com'),
(5,'David','Finance',75000,'david@company.com'),
(6,'Alex','IT',90000,'alex@company.com'),
(7,'Sophia','HR',65000,'sophia@company.com'),
(8,'Daniel','IT',80000,'daniel@company.com');

CREATE TABLE customers (
customer_id INT,
name VARCHAR(50),
email VARCHAR(100),
city VARCHAR(50)
);

INSERT INTO customers VALUES
(1,'Amit','amit@email.com','Delhi'),
(2,'Neha','neha@email.com','Mumbai'),
(3,'Rahul','rahul@email.com','Delhi'),
(4,'Priya','priya@email.com','Bangalore'),
(5,'Karan','karan@email.com','Mumbai'),
(6,'Simran','simran@email.com','Pune');

CREATE TABLE orders (
order_id INT,
customer_id INT,
product_id INT,
order_date DATE,
amount INT
);

INSERT INTO orders VALUES
(101,1,1,'2024-01-01',500),
(102,2,2,'2024-01-03',700),
(103,1,3,'2024-01-05',300),
(104,3,1,'2024-02-01',1000),
(105,4,2,'2024-02-05',400),
(106,5,3,'2024-03-01',900),
(107,2,1,'2024-03-02',600),
(108,1,2,'2024-03-05',800);

CREATE TABLE products (
product_id INT,
product_name VARCHAR(50),
category VARCHAR(50),
price INT
);

INSERT INTO products VALUES
(1,'Laptop','Electronics',50000),
(2,'Mobile','Electronics',20000),
(3,'Headphones','Accessories',2000),
(4,'Keyboard','Accessories',1500);

CREATE TABLE logins (
user_id INT,
login_date DATE
);

INSERT INTO logins VALUES
(1,'2024-01-01'),
(1,'2024-01-02'),
(1,'2024-01-03'),
(2,'2024-01-01'),
(2,'2024-01-03'),
(3,'2024-01-01'),
(3,'2024-01-02');

CREATE TABLE monthly_revenue (
month VARCHAR(10),
revenue INT
);

INSERT INTO monthly_revenue VALUES
('Jan',5000),
('Feb',7000),
('Mar',6500),
('Apr',9000);

Create procedure table_view 
AS 
begin
Select*from customers;
Select*from employees;
Select*from logins;
Select*from monthly_revenue;
Select*from orders;
Select*from products;
END;

Exec table_view;

-- Second higesy salary 

Select MAX(Salary) from employees 
where Salary < (Select MAX(Salary) from employees) ;

-- find duplicate rows

Select email, count(*) from employees 
group by email having count(*)>1;

-- delete duplicat rows (keeping 1st record)

Delete from employees
where email NOT IN(Select MIN(email) 
from employees group by email);

-- customers who nmever ordered

select c.customer_id from 
customers c left join orders o
ON c.customer_id = o.customer_id
where o.order_id IS NULL;

-- top 5 higest salary

Select TOP 5 salary 
from employees 
order by salary DESC;

-- Revenue per month

Select month(order_date) as month, 
SUM(amount) as revenue 
from orders 
group by month (order_date);

-- average salary per department

Select department, AVG(salary)
From employees group by department;

-- find latest order per customer

Select customer_id, MAX(order_date)
FROM orders group by customer_id;

-- running total sales

Select SUM (amount) OVER(ORDER by order_date) as running_total
from orders;

-- rank employees by salary

Select salary, name from employees 
order by salary Desc;

--or
Select salary, name,
RANK() over( order by salary DESC) as salary_rank
from employees;

--find top product in each category

Select category from (
select category, price, product_name
, RANK() OVER(Partition by category order by price desc)r
from products) t
where r = 1;

-- find employees earning above average

select avg(salary) as above_avg_salary from employees 
where salary > (Select AVG(salary) from employees);

-- custx with more than 2 orders

Select customer_id, count (order_id) from 
orders group by customer_id having count(order_id) > 2;

-- if also need name with above conditions

Select c.name,count(order_id)  from customers c 
left join orders o on c.customer_id = o.customer_id 
group by c.name,c.customer_id having count(order_id)>2;

-- find the first purchase of each customer 

select order_id, min(order_date) 
from orders 
Group by order_id,customer_id;

-- IMPORTANT monthover month revenue growth 

SELECT month, 
revenue,
revenue - LAG(revenue) OVER(order by month)as growth 
FROM monthly_revenue;

-- find the users active 3 consecutive days

Select user_id
from logins
group by user_id
having count(distinct login_daTE)>=3;

-- FIND PRODUCTS WITH HIGHEST SALES 

SELECT TOP 1 product_name
FROM products
ORDER BY price DESC;

-- replace null values / my tables are clean hence no null values are present, below is just an example.

Select name, 
COALESCE(laptop, 'n/a')
from customers;

-- find daily active users

select login_date,
count(distinct user_id) 
from logins 
group by login_date;

-- top 3 products by revenue

Select top 3 product_id, sum(amount)
from orders
group by product_id 
order by sum(amount) DESC;

-- customer who ordered last month 

Select distinct customer_id 
from orders 
where DATEDIFF(month, order_date, GETDATE())=1;

-- find missing customer IDs

Select * from orders 
where customer_id  is null;

-- total orders per customer

select customer_id, count(order_id)
from orders
group by customer_id;

-- rolling 7-day sales average 

Select order_date,
avg(amount) over(
order by order_date
ROWs BETWEEN 6 preceding and current row) as 
rollin_avg
from orders;

-- END --
-- Thanks visit again -- 
