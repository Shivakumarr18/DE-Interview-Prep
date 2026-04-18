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
