# Recover Accidentally Deleted Data using Time Travel Feature

## Problem Statement
An analyst accidentally deletes a record from the EMPLOYEE table. The deleted data is critical for business, and the team needs to recover it without downtime or backup restoration.

## Project Overview
In this mini project, you will:

Learn how we can use the time travel feature of snowflake to recover the accidentally deleted data from the table without performing backup or downtime

Use the time travel feature of offset to recover deleted data

## PTools/Technologies Used
Snowflake: Cloud-based data warehouse

Snowflake Web UI: SQL execution environment

 

## PHigh Level Step-by-Step Implementation
1. Create a Database & Schema

Database : TIMETRAVEL_DB

Schema : TIMETRAVEL_DATA

2. Create EMPLOYEE Table in the TIMETRAVEL_DATA schema

Table : 

Database: TIMETRAVEL_DB

Schema: TIMETRAVEL_DATA 

Name: EMPLOYEE

Table structure

EMPLOYEE_ID STRING

FIRST_NAME STRING

LAST_NAME STRING

DEPARTMENT STRING

SALARY FLOAT

HIRE_DATE DATE

 

3. Populate the Table

Insert the below data in the above EMPLOYEE table by running the following insert statement

 

INSERT INTO TIMETRAVEL_DB.TIMETRAVEL_DATA.EMPLOYEE VALUES 

('E1', 'John', 'Doe', 'Finance', 75000.50, '2020-01-15'), 

('E2', 'Jane', 'Smith', 'HR', 68000.00, '2018-03-20'), 

('E3', 'Alice', 'Johnson', 'IT', 92000.75, '2019-07-10'),

 ('E4', 'Bob', 'Williams', 'Sales', 58000.25, '2021-06-01'), 

('E5', 'Charlie', 'Brown', 'Marketing', 72000.00, '2022-04-22'), 

('E6', 'Emily', 'Davis', 'IT', 89000.10, '2017-11-12'), 

('E7', 'Frank', 'Miller', 'Finance', 83000.30, '2016-09-05'), 

('E8', 'Grace', 'Taylor', 'Sales', 61000.45, '2023-02-11'),

 ('E9', 'Hannah', 'Moore', 'HR', 67000.80, '2020-05-18'), 

('E10', 'Jack', 'White', 'Marketing', 70000.90, '2019-12-25');

 

4. View the Current Data in the EMPLOYEE table

 

Retrieve all records to confirm the EMPLOYEE table's content by running the select query

 

5. Simulate Data Deletion

 

Delete EMPLOYEE_ID E2 and E7 record for the EMPLOYEE table to simulate accidental deletion by running a delete query.

 

6. Verify the Deletion

Check the EMPLOYEE table's content by running the select query to ensure the record is deleted.

7. Fetch the QUERY_ID of the DELETE statement

Fetch the QUERY_ID of the previous executed DELETE statement from the SNOWFLAKE QUERY_HISTORY table







Recovering Deleted Data

8. Use Time Travel to Access Historical Data

To retrieve the deleted record, query the EMPLOYEE table's state just before the deletion by using the time travel feature of snowflake

Check the below snowflake Time Travel tutorial for reference : https://my.dataengineeracademy.com/mod/url/view.php?id=631

9. Recover the Deleted Record

To restore the deleted record, insert it back into the table by running the insert command

10. Verify the Recovery

Query the EMPLOYEE table again to confirm the record is restored.
