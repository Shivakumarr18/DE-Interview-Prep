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
-- Sort by remaining_budget descending. Include Marketing (0 salary spent).

select d.dept_name, coalesce(sum(e.salary),0) as total_salary, d.budget,
(d.budget-coalesce(sum(salary),0)) as remaining_budget from departments as d
left join employees as e on d.dept_name = e.department
group by d.dept_name, d.budget
order by remaining_budget desc;