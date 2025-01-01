Use prep;

-- Q1. Write a query to calculate the median salary of employees in a table.

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each employee
    FirstName VARCHAR(50),            -- Employee's first name
    LastName VARCHAR(50),             -- Employee's last name
    Salary DECIMAL(10, 2),            -- Employee's salary with two decimal places
    HireDate DATE,                    -- Employee's hire date
    Department VARCHAR(50)            -- Department where the employee works
);

INSERT INTO Employee (FirstName, LastName, Salary, HireDate, Department) VALUES
('John', 'Doe', 50000.00, '2021-05-10', 'IT'),
('Jane', 'Smith', 60000.00, '2020-03-15', 'HR'),
('Michael', 'Brown', 55000.00, '2019-06-25', 'Finance'),
('Emily', 'Davis', 70000.00, '2022-01-20', 'IT'),
('Chris', 'Johnson', 65000.00, '2021-08-12', 'HR'),
('Ane', 'Sam', 45000.00, '2021-05-15', 'Sales'),
('William', 'Paul', 68000.00, '2020-06-15', 'Finance'),
('Michael', 'Harry', 62000.00, '2019-06-25', 'Sales');

select * from employee;

WITH CTE AS (
    SELECT 
        Salary,
        ROW_NUMBER() OVER (ORDER BY Salary ASC) AS rnk_asc,
        ROW_NUMBER() OVER (ORDER BY Salary DESC) AS rnk_dsc
    FROM Employee
)
SELECT AVG(Salary) AS Median_Salary
FROM CTE
WHERE ABS(CAST(rnk_asc AS SIGNED) - CAST(rnk_dsc AS SIGNED)) <= 1;

-- The ROW_NUMBER() function generates ranks as unsigned integers (BIGINT UNSIGNED).
-- CAST(rnk_asc AS SIGNED) converts the unsigned integer to a signed integer (which can hold both positive and negative values). 
-- This ensures the subtraction operation works properly, even if the result is negative.

-- Q.2 Find the nth highest salary in employee table

select distinct(salary) from Employee
order by salary desc 
LIMIT 1 offset 1; -- difine n-1 position in offset;

-- Q.3 Find the nth highest salry in department 
set @n = 1;
With CTE as 
(select *, dense_rank() over(Partition by Department order by salary desc) as sal_rnk 
from Employee)
 select salary, Department from CTE 
 where sal_rnk = @n;
 
 
-- Q4. Find the most occuring salary
With CTE as
( Select salary, count(*) as frequency from employee group by salary)
 select * from cte 
 where frequency = (select max(frequency) from cte);
 
-- with rank function
With mode_cte as (
Select salary, count(*) as frequency from employee group by salary),
rnk_cte as
(select *, rank() over ( order by frequency desc) as rnk from mode_cte)
select salary from rnk_cte where rnk =1;

-- Q5. Find the Average salary departmentwise

Select distinct(department) , avg(salary) over(partition by department ) as Average_salary  from employee order by Average_salary; -- by using windows aggregation

select department , avg(salary) as Average_salary from employee
group by department 
order by Average_salary

