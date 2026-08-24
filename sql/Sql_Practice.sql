CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    department VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Ravi', 80000, 'Engineering'),
(2, 'Priya', 90000, 'Engineering'),
(3, 'Amit', 70000, 'Engineering'),
(4, 'Sneha', 85000, 'Sales'),
(5, 'Kiran', 75000, 'Sales'),
(6, 'Meena', 95000, 'Sales'),
(7, 'Arjun', 60000, 'HR'),
(8, 'Divya', 65000, 'HR');

select * from employees;

#Problem 1: Find the second highest salary in each department.
select e.salary, e.department from (
select salary, department, row_number() over(
partition by department order by salary desc) rnk
from employees) as e
where rnk = 2;

#write a query that shows each employee's name, salary, department, and the difference between their
#salary and the highest salary in their department. Call the column gap_from_top.

select e.name, e.salary, e.department,
 (max(e.salary) over( partition by e.department) - e.salary) as gap_from_top
 from employees as e;
 
 #Problem 3: Show departments where total salary exceeds 200,000. Include department, total salary,
--  employee count, and average salary rounded to 0 decimals.
SELECT e.department, COUNT(e.id) AS employee_count, SUM(e.salary) AS total_salary, 
ROUND(AVG(e.salary), 0) AS avg_salary from employees as e
group by e.department
having sum(e.salary)> 200000
order by total_salary desc;

#Problem 4: For each employee, show their name, salary, department, and the rank of their salary
--  within their department (highest = 1). Handle ties with the same rank.
select e.id, e.name, e.salary, e.department from(
select id, name, salary, department, dense_rank() over(
partition by department order by salary desc) as dr
from employees) as e
where e.dr = 1;

#Problem 5: Find employees who earn more than the average salary of their department. Show name, salary,
--  department, and department's average salary.
select e.name, e.salary, e.department, dept_avg_salary from(
select name, salary, department, avg(salary) over(
partition by department) as dept_avg_salary
from employees) as e
where salary > dept_avg_salary;

#Problem 6: For each department, show the highest paid and lowest paid employee names in a single row.
--  (Output: department, highest_paid_name, lowest_paid_name)
SELECT DISTINCT
    department,
    FIRST_VALUE(name) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_paid_name,
    FIRST_VALUE(name) OVER(PARTITION BY department ORDER BY salary ASC) AS lowest_paid_name
FROM employees;

-- Problem 7: Show each employee's name, salary, and the running total of salaries within their department,
--  ordered by salary ascending.
SELECT 
    name, 
    salary, 
    department,
    SUM(salary) OVER(PARTITION BY department ORDER BY salary ASC) AS running_total
FROM employees;

-- Problem 8: Find the top 2 highest paid employees in each department. If there are ties at rank 2,
--  include all tied employees.
SELECT name, salary, department
FROM (
    SELECT 
        name, salary, department,
        DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) as rnk
    FROM employees
) AS ranked_table
WHERE rnk <= 2;
-- Problem 9: For each employee, show their name, salary, and the salary of the person ranked immediately
--  above them in the same department. If they're the highest paid in their department, show NULL.
SELECT 
    name, 
    salary,
    LAG(salary) OVER(PARTITION BY department ORDER BY salary ASC) AS salary_above
FROM employees;
-- Problem 10: Show each department along with the percentage contribution of each employee's salary to
--  the department's total salary. Round to 2 decimals.
SELECT 
    department,
    name,
    salary,
    ROUND(
        (salary * 100.0) / SUM(salary) OVER(PARTITION BY department), 
        2
    ) AS percentage_contribution
FROM employees;

-- Day 2 SQL — Aggregations & GROUP BY (10 problems)
-- Part A — employees table (Problems 1-6)

-- Problem 1: For each department, show the department name and total salary. Only include departments
 -- where the total salary exceeds 150,000.
select e.department, sum(e.salary) as total_salary from employees as e
group by e.department
having sum(e.salary) > 150000
order by total_salary desc;

-- Problem 2: Find departments where the average salary is greater than the overall company average
--  salary. Return department name and its average salary.
select e.department, avg(e.salary) as avg_salary from employees as e
group by e.department
having avg(salary) > (select avg(salary) from employees);
 
-- Problem 3: For each department, show the number of employees, total salary, and the difference
--  between the highest and lowest salary in that department. Sort by the difference descending.
select e.department, count(e.id) as number_of_employees, sum(e.salary) as total_salary,
max(e.salary) - min(e.salary) as salary_difference from employees as e
group by e.department
order by salary_difference desc;
 
-- Problem 4: Find departments that have more than 2 employees AND where the maximum salary in that
--  department is greater than 85,000. Return department name, employee count, and max salary.
 select e.department, count(e.id) as employee_count, max(e.salary) as max_salary from employees as e
 group by e.department
 having count(e.id) > 2 and max(e.salary) > 85000;
 
-- Problem 5: For each department, calculate what percentage its total salary contributes to the
--  overall company salary. Round to 2 decimals. (Hint: you'll need a subquery or a windowed total.)
 select e.department, sum(e.salary) as total_dept_salary,
 round(sum(e.salary) * 100.0 / sum(sum(e.salary)) over(), 2) as percentage_contribution
 from employees as e
 group by e.department;
 
-- Problem 6: Find the department with the highest average salary. Return just one row: department name
--  and its average salary. (Don't use LIMIT — solve it with HAVING or a subquery so it handles ties 
-- correctly.)
select e.department, avg(e.salary) as avg_salary from employees as e
group by e.department
having avg(e.salary) = (SELECT MAX(dept_avg) FROM (
SELECT AVG(salary) AS dept_avg FROM employees
GROUP BY department) AS subquery);

-- Problem 7: For each flight_phase, count the number of incidents. Show only those flight phases with
--  more than 100 incidents. Sort descending by count.
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT aircraft_id) AS unique_aircrafts
FROM dim_aircraft;

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT aircraft_id) AS unique_aircrafts
FROM fact_incidents;

select da.flight_phase, count(fa.incident_id) as number_of_incidents from dim_aircraft as da
join fact_incidents as fa on da.aircraft_id = fa.aircraft_id
group by da.flight_phase
having count(fa.incident_id) > 100
order by number_of_incidents desc;

-- Problem 8: For each operator in dim_aircraft, find the total number of incidents and the average
-- altitude of those incidents. Show only operators with at least 50 incidents. Round average altitude 
--  to 0 decimals.
select * from fact_incidents;

select da.operator, count(fa.incident_id) as total_incidents,
round(avg(fa.altitude),0) as avg_altitude from dim_aircraft as da
join fact_incidents as fa on da.aircraft_id = fa.aircraft_id
group by da.operator
having count(fa.incident_id) >= 50;

-- Problem 9: For each year (from dim_time), show:
-- Total incident count
-- Number of incidents that happened on weekends (is_weekend = 1)
-- Percentage of weekend incidents (rounded to 2 decimals)
-- Sort by year ascending.
select * from dim_time;

select count(*) as total_rows, count(distinct time_id) as unique_rows from dim_time;
select count(*) as total_rows, count(distinct time_id) as unique_rows from fact_incidents;

SELECT dt.year, COUNT(fa.incident_id) AS total_incidents,
    SUM(CASE WHEN dt.is_weekend THEN 1 ELSE 0 END) AS weekend_incidents,
    ROUND(
	SUM(CASE WHEN dt.is_weekend THEN 1 ELSE 0 END) * 100.0 / COUNT(fa.incident_id) ,2)
    AS weekend_percentage
FROM fact_incidents AS fa
JOIN dim_time AS dt ON fa.time_id = dt.time_id
GROUP BY dt.year
ORDER BY dt.year asc;

-- Problem 10 (the hardest one — classic interview trap):
-- Find the top 3 flight_conditions (from dim_environment) with the highest average altitude of incidents.
-- But here's the twist — only count incidents where the primary_problem is NOT NULL.
-- Return: flight_conditions, incident_count, avg_altitude.
-- (Watch out for: NULL handling in primary_problem, duplication from joins, and tie-breaking at rank 3.)

select * from dim_environment;

select count(*) as total_rows, count(distinct environment_id) as unique_rows from dim_environment;
select count(*) as total_rows, count(distinct environment_id) as unique_rows from fact_incidents;

SELECT flight_conditions, incident_count, avg_altitude
FROM (
    SELECT de.flight_conditions, COUNT(fi.incident_id) AS incident_count,
        ROUND(AVG(fi.altitude), 2) AS avg_altitude,
        DENSE_RANK() OVER (ORDER BY AVG(fi.altitude) DESC) AS rnk
    FROM fact_incidents AS fi
    JOIN dim_environment AS de ON fi.environment_id = de.environment_id
    WHERE fi.primary_problem IS NOT NULL
    GROUP BY de.flight_conditions
) AS ranked
WHERE rnk <= 3;

CREATE TABLE departments (
    dept_name VARCHAR(50) PRIMARY KEY,
    location VARCHAR(50),
    budget INT
);

INSERT INTO departments VALUES
('Engineering', 'Hyderabad', 500000),
('Sales', 'Bangalore', 300000),
('HR', 'Chennai', 150000),
('Marketing', 'Mumbai', 200000);

-- #Show every employee's name, salary, department, and the location of their department.

select count(*) as total_rows, count(distinct dept_name) as unique_rows from departments;
select count(*) as total_rows, count(distinct department) as unique_rows from employees;

select e.name, e.salary, e.department, d.location from employees as e
join departments as d on e.department = d.dept_name
order by e.salary desc;

-- Problem 2 — LEFT JOIN with empty side
-- Show ALL departments and the count of employees in each. Include departments with zero employees.
-- Output: dept_name, location, employee_count

select d.dept_name, d.location, count(e.id) as employee_count from departments as d
left join employees as e on d.dept_name = e.department
group by d.dept_name, d.location;

-- Problem 3 — Filter on right table of LEFT JOIN
-- Show ALL departments and their employees who earn more than 75,000. Include departments where no
-- such high-earner exists (show NULL for the employee).
-- Output: dept_name, name, salary

select d.dept_name, e.name, e.salary from departments as d
left join employees as e on d.dept_name = e.department and e.salary > 75000;

-- Problem 4 — Multi-table join with aggregation
-- For each department, show:
-- dept_name
-- total salary spent in that department
-- department budget
-- remaining budget (budget - total salary)
-- Sort by remaining_budget descending. Include Marketing (0 salary spent)

select d.dept_name, coalesce(sum(e.salary),0) as total_salary, d.budget,
(d.budget-coalesce(sum(salary),0)) as remaining_budget from departments as d
left join employees as e on d.dept_name = e.department
group by d.dept_name, d.budget
order by remaining_budget desc;

DROP DATABASE success;
CREATE DATABASE sql_prep;
USE sql_prep;

-- 1. Aggregations & GROUP BY
-- Total, average, count by group. Foundation of all analysis.
-- Key keywords: GROUP BY, SUM, COUNT, AVG, HAVING

-- SQL_Practice_1_Ecommerce.xlsx (customers, orders)
-- ❓ Find the total revenue and order count per country, only for delivered orders.
--  Sort by revenue descending.
select * from customers ;
select * from orders;

select c.country, count(o.order_id) as order_count, sum(o.total_amount) as Total_revenue from customers as c
join orders as o on c.customer_id = o.customer_id
where o.order_status = "Delivered"
group by c.country
order by total_revenue desc;

-- Q1.2 — Average order value per customer segment
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (customers, orders)
-- ❓ Find the average order value (AOV) per customer segment. Show only segments with more
--  than 5 delivered orders.

select c.segment, count(o.order_id) as order_count, round(avg(o.total_amount),2) as avg_order_value
from customers as c
join orders as o on c.customer_id = o.customer_id
where o.order_status = 'Delivered'

-- Q1.3 — Count of unique customers per month
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (orders)
-- ❓ How many unique customers placed an order each month in 2024?

select count(distinct o.customer_id) as unique_customer, month(o.order_date) as month_num from orders as o
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
group by month_num
order by month_num desc;

-- Q1.4 — Categories with revenue above $50,000
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (products, order_items)
-- ❓ List product categories whose total revenue (qty × unit_price) exceeds $50,000.

select * from order_items;
select p.category, sum(o.quantity * o.unit_price) as total_revenue from order_items as o
join products as p on o.product_id = p.product_id
group by p.category
having sum(o.quantity * o.unit_price) > 50000
order by total_revenue desc;

-- Practice_Problems(2):

-- Find the top 3 customer segments by  total revenue AND average order value.
-- But only include:
-- → Orders placed in 2024
-- → Order status = 'Delivered'
-- → Segments with more than 10 orders
-- Show: segment, total_orders, total_revenue, avg_order_value Sort: total_revenue descending

select c.segment, count(o.order_id) as total_orders, sum(o.total_amount) as total_revenue,
round(avg(o.total_amount),2) as avg_order_value from orders as o 
join customers as c on o.customer_id = c.customer_id
where o.order_status = 'Delivered' AND o.order_date >= '2024-01-01' AND o.order_date < '2025-01-01'
group by c.segment
having count(o.order_id) > 10
order by total_revenue desc
limit 3;

-- For each product category find:
-- → total_orders (count of order_items)
-- → total_revenue (quantity × unit_price)
-- → avg_revenue_per_order
-- → max_single_order_value (max of quantity × unit_price)
-- Only include categories where:
-- → total_revenue > 10,000
-- → total_orders > 20
-- Sort by avg_revenue_per_order descending

select p.category, count(o.order_item_id) as total_orders, sum(o.quantity * o.unit_price) as total_revenue,
round(avg(o.quantity * o.unit_price),2) as avg_revenue_per_order, max(o.quantity * o.unit_price) as 
max_single_order_value from order_items as o
join products as p on o.product_id = p.product_id
group by p.category
having sum(o.quantity * o.unit_price) > 10000 and count(o.order_item_id) > 20
order by avg_revenue_per_order desc;

#Important Concept to remeber. 

SELECT
    p.category,
    MAX(oi.quantity * oi.unit_price)  AS max_order_value,
    MIN(oi.quantity * oi.unit_price)  AS min_order_value,
    AVG(oi.quantity * oi.unit_price)  AS avg_order_value,
    STDDEV(oi.quantity * oi.unit_price) AS std_deviation,
    COUNT(oi.order_item_id)           AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;

#Day_2:

-- Q2.1 — Customers who never placed an order
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (customers, orders)
-- ❓ Find all customers who have never placed an order.

select c.customer_id, c.customer_name, c.country from customers as c
left join orders as o on c.customer_id = o.customer_id
where o.order_id is Null;

-- Q2.2 — Customers and their order count, including those with zero orders
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (customers, orders)
-- ❓ Show every customer with their order count. Customers with no orders should show 0.

select c.customer_id, c.customer_name, count(o.order_id) as order_count from customers as c
left join orders as o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by order_count desc;

-- Q2.3 — Products that have never been ordered
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (products, order_items)
-- ❓ Find all products that have never appeared in any order.

select * from products;
select * from customers;
select * from order_items;

select p.product_name from products as p
left join order_items as oi on p.product_id = oi.product_id
where oi.order_item_id is null;

-- Q2.4 — Three-table join: orders with customer name and product details
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (all 4 sheets)
-- ❓ Show the order_id, customer name, product name, quantity, and total line value for all
--  delivered orders.

select o.order_id, c.customer_name, p.product_name, oi.quantity, (oi.quantity * oi.unit_price) as 
total_line_value from order_items as oi
join orders as o on oi.order_id = o.order_id
join customers as c on o.customer_id = c.customer_id
join products as p on oi.product_id = p.product_id
where o.order_status = 'Delivered'
order by o.order_id;

-- Practice Problems on Pattern-2:

-- 1. Find all customers who are from the same country as customer named 'Alice Johnson'.
-- Show: customer_name, country
-- Exclude Alice Johnson from the results.
-- Table: customers
-- Hint: JOIN customers table to itself

select c.customer_name, c.country from customers as c
join customers as c1 on c.country = c1.country
where c1.customer_name = 'Alice Johnson' and c.customer_name <> 'Alice Johnson';

-- 2. For each product category, show: total_orders (count of order_items)
-- → total_revenue (quantity × unit_price), total_customers (distinct customers who ordered)
-- Only include delivered orders.
-- Sort by total_revenue descending.
-- Tables: products, order_items, orders, customers

select p.category, count(oi.order_item_id) as Total_orders, sum(oi.quantity * oi.unit_price) as
Total_revenue, count(distinct c.customer_id) as Total_customers from order_items as oi
join orders as o on oi.order_id = o.order_id
join customers as c on o.customer_id = c.customer_id
join products as p on oi.product_id = p.product_id
where o.order_status = 'Delivered'
group by p.category
order by Total_revenue desc;

-- Day 3: 

-- Q3.1 — Top 3 products by revenue per category
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (products, order_items)
-- ❓ For each product category, find the top 3 products by total revenue.

select * from (
select p.product_name, p.category, sum(oi.quantity * oi.unit_price) as total_revenue, row_number()
over(partition by p.category order by sum(oi.quantity * oi.unit_price) desc) as rn
from order_items as oi
join products as p on oi.product_id = p.product_id
group by p.category, p.product_name ) ranked 
where rn <=3
order by category, rn

-- Q3.2 — Each customer's most expensive order
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (customers, orders)
-- ❓ For each customer, find their most expensive order.
select * from orders;

with ranked as (
select c.customer_name, o.order_id, o.total_amount, row_number() 
over(partition by c.customer_id order by o.total_amount desc) as rn
from orders as o
join customers as c on o.customer_id = c.customer_id
)
select * from ranked
where rn = 1
order by total_amount desc;

-- Q3.3 — Rank customers by total spend (handle ties)
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (customers, orders)
-- ❓ Rank all customers by their total delivered-order spend. Customers with the
--  same spend should share the same rank.

SELECT c.customer_id,c.customer_name,SUM(o.total_amount) AS total_spend, DENSE_RANK()
OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY spend_rank;

-- Q3.4 — Each customer's first and last order
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (orders)
-- ❓ For each customer, find both their first and last order date.

SELECT c.customer_id, c.customer_name,  MIN(o.order_date) AS first_order, 
MAX(o.order_date) AS last_order, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;

-- Practice Problems :

-- Find the 2nd highest spending customer overall.
-- Show: customer_name, total_spent, rank
-- Delivered orders only.

WITH customer_spend AS (
  SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.order_status = 'Delivered'
  GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name, total_spent, spend_rank AS ranks FROM customer_spend
WHERE spend_rank = 2;

-- For each country, find the customer who placed
-- the most orders. Show:
-- country, customer_name, order_count, rank
-- Only show rank = 1 per country.
-- Delivered orders only.

WITH country_order_counts AS (
  SELECT c.country,c.customer_id,c.customer_name,COUNT(o.order_id) AS order_count,DENSE_RANK()
  OVER (PARTITION BY c.country ORDER BY COUNT(o.order_id) DESC) AS country_rank
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.order_status = 'Delivered'
  GROUP BY c.country, c.customer_id, c.customer_name
)
SELECT country, customer_name,order_count,country_rank AS rankss
FROM country_order_counts
WHERE country_rank = 1
ORDER BY country;

-- Pattern : 4
-- Q4.1 — Running total of monthly revenue
-- 📂 File: SQL_Practice_3_Sales.xlsx (daily_sales)
-- ❓ Show monthly revenue along with the cumulative running total for the year.

select * from daily_sales;
with Monthly as (
select date_format(sale_date, '%Y-%m') as months, sum(revenue) as monthly_revenue from daily_sales
group by months
)
select months, monthly_revenue, 
sum(monthly_revenue) over (order by months) as running_total from monthly
order by months;

-- Q4.2 — Month-over-month revenue change using LAG
-- 📂 File: SQL_Practice_3_Sales.xlsx (daily_sales)
-- ❓ For each month, show the revenue, the previous month's revenue, and the % change.

with monthly as (
select date_format(sale_date, '%Y-%m') as months, sum(revenue) as monthly_revenue from daily_sales
group by months
)
select months, monthly_revenue, lag(monthly_revenue) over (order by months) as previous_month , 
ROUND(
    (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY months)) /
    NULLIF(LAG(monthly_revenue) OVER (ORDER BY months), 0) * 100
, 2) AS pct_change from monthly
order by months;

-- Q4.3 — 7-day moving average of daily revenue
-- 📂 File: SQL_Practice_3_Sales.xlsx (daily_sales)
-- ❓ Compute the 7-day moving average of daily revenue across all regions.

select * from daily_sales;

with daily_revenue as (
select sale_date, sum(revenue) as daily_revenue from daily_sales
group by sale_date
)
select sale_date, daily_revenue, 
round(avg(daily_revenue) over (order by sale_date rows between 6 preceding and current row),2)
as moving_avg_7days_delay from daily_revenue
order by sale_date;

-- Q4.4 — Time between consecutive orders per customer
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (orders)
-- ❓ For each customer, calculate the days between consecutive orders.

select o.customer_id, o.order_date, LAG(o.order_date) 
OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as previous_order, 
datediff(o.order_date , LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date)) as days_difference from orders as o
order by o.order_date;

-- Version-2 (Query optimization)
WITH order_lag AS (
    SELECT  customer_id, order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order
    FROM orders
)
SELECT customer_id, order_date, previous_order, DATEDIFF(order_date, previous_order) AS days_difference
FROM order_lag
ORDER BY order_date;

-- PATTERN 5 — CTEs & Subqueries
-- 💡 Why this pattern matters
-- Complex problems need to be broken into steps. CTEs (WITH clauses) make queries readable.
--  Always prefer CTEs over nested subqueries — interviewers love readable code.

-- Q5.1 — Customers who spent more than the average customer
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (customers, orders)

select * from customers;
select * from orders;

with customer_total_spend as (
select customer_id, sum(total_amount) as total_spend from orders
where order_status = 'Delivered'
group by customer_id
),
avg_spend as (
select avg(total_spend) as overall_avg from customer_total_spend)
select c.customer_id, c.customer_name, ct.total_spend from customer_total_spend as ct
join customers as c on ct.customer_id = c.customer_id
cross join avg_spend as a
where ct.total_spend > a.overall_avg
order by ct.total_spend desc;

-- Q5.2 — Customers who ordered both Electronics and Furniture
-- 📂 File: SQL_Practice_1_Ecommerce.xlsx (all sheets)
-- ❓ Find customers who have ordered both Electronics AND Furniture products.

select * from order_items;
select * from customers;
select * from products;
select * from orders;

WITH customer_categories AS (
  SELECT DISTINCT o.customer_id, p.category FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  WHERE p.category IN ('Electronics', 'Furniture')
)
SELECT customer_id FROM customer_categories
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 2;





