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

