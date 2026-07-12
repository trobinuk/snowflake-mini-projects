CREATE DATABASE employee_data;

USE employee_data;

CREATE SCHEMA raw_data;

CREATE SCHEMA transformed_data;

USE employee_data.raw_data;

CREATE TABLE employee_raw
(
EMPLOYEE_ID STRING,
FIRST_NAME STRING,
LAST_NAME STRING,
DEPARTMENT STRING,
SALARY DECIMAL(10,2),
HIRE_DATE DATE,
LOCATION STRING
);

select * from employee_raw;

USE employee_data.transformed_data;

CREATE TABLE employee_transformed
(
EMPLOYEE_ID STRING,
FULL_NAME STRING,
DEPARTMENT STRING,
ANNUAL_SALARY DECIMAL(10, 2),
HIRE_DATE DATE,
EXPERIENCE_LEVEL STRING,
TENURE_DAYS STRING,
STATE STRING,
COUNTRY STRING,
BONUS_ELIGIBILITY STRING,
HIGH_POTENTIAL_FLAG STRING
);

USE employee_data.raw_data;

CREATE OR REPLACE STAGE employee_stage;

LIST @employee_stage;

SELECT $1, $2, $3, $4, $5
FROM @employee_stage/employee_data.csv
--(FILE_FORMAT => 'EMPLOYEE_DATA.RAW_DATA.MY_CSV_FORMAT')
LIMIT 10;

COPY INTO employee_raw
FROM @employee_stage/employee_data.csv
FILE_FORMAT = (TYPE='CSV' SKIP_HEADER=1);

SELECT *
FROM employee_raw
LIMIT 30;


INSERT INTO employee_data.transformed_data.employee_transformed
WITH employee AS 
(
    SELECT EMPLOYEE_ID,
            CONCAT(FIRST_NAME,LAST_NAME) AS full_name,
            department,
            SALARY*12 AS annual_salary,
            hire_date,
            DATEDIFF(YEAR,hire_date,CURRENT_DATE) AS years_experience,
            DATEDIFF(day,hire_date,CURRENT_DATE) AS tenure_days,
            SPLIT_PART(location,'-',1) AS state,
            SPLIT_PART(location,'-',-1) AS country,
            location,
            SALARY
    FROM employee_data.raw_data.employee_raw)
SELECT EMPLOYEE_ID,
        full_name,
        department,
        annual_salary,
        hire_date,
        CASE WHEN years_experience < 1 THEN 'New Hire'
             WHEN years_experience >= 1 AND years_experience <= 5 THEN 'Mid-level'
             ELSE 'Senior' END AS experience_level,
       tenure_days,
       state,
       country,
       CASE WHEN SALARY > 10000 THEN 'Eligible'
            ELSE 'Not Eligible' END AS bonus_eligibility,
       CASE WHEN years_experience > 3 THEN 'High-Potential'
            ELSE 'NA' END  AS high_potential_flag
FROM employee;

--SELECT CURRENT_DATE;

SELECT *
FROM employee_data.transformed_data.employee_transformed
--Employee Count by Department
SELECT department,
        COUNT(employee_id) employee_count
FROM employee_data.transformed_data.employee_transformed
GROUP BY department
--Provide count of employees by country
SELECT country,
        COUNT(employee_id) employee_count
FROM employee_data.transformed_data.employee_transformed
GROUP BY country
--Extract employees who were hired within 12 months
SELECT *
FROM employee_data.transformed_data.employee_transformed
WHERE experience_level = 'New Hire'
--Extract the top 10% of employees by salary
WITH ranked_emp AS 
(
    SELECT ROW_NUMBER() OVER (ORDER BY annual_salary DESC) rnk,
            *
    FROM employee_data.transformed_data.employee_transformed
),
ten_percent AS
(
    SELECT (10/COUNT(employee_id))*100 AS ten_percent
    FROM employee_data.transformed_data.employee_transformed
)
SELECT *
FROM ranked_emp
WHERE rnk <= (SELECT ten_percent FROM ten_percent)

--Calculate the total salary expense per department for each year.
SELECT department,
        SUM(annual_salary) AS annual_salary
FROM employee_data.transformed_data.employee_transformed
GROUP BY department;

--Determine how many employees with 5+ years with company
SELECT *
FROM employee_data.transformed_data.employee_transformed
WHERE experience_level = 'Senior'
