# Unstructured Data - Simple JSON + Internal Stage + Copy Command 
## Project Overview
In this mini project, you will:

Load customer data from a JSON file into a raw table in Snowflake using the internal stage.

Perform JSON flattening on the raw table and create a flatten table 

Perform data analysis on the flatten data

## Objectives
Learn how to work with Snowflake's internal stages for file storage.

Use the COPY INTO command to load unstructured data into the Snowflake table.

Perform simple JSON Flattening in snowflake.

Set up raw and flatten tables in Snowflake for analytics purposes.

## Tools/Technologies Used
Snowflake: Cloud-based data warehouse

Snowflake Web UI: SQL execution environment

JSON File: Sample Customer data

 
## Architecture


## High Level Step-by-Step Implementation
1. Create a Database & Schema

Database : CUSTOMER_DATA

Schema : RAW_DATA

Schema : FLATTEN_DATA

2. Create Raw Table in the RAW_DATA schema

Table : 

Database: CUSTOMER_DATA

Schema: RAW_DATA

Name: CUSTOMER_RAW 

Table structure

JSON_DATA VARIANT

3. Create flatten table in the FLATTEN_DATA schema

Table Name : 

Database: CUSTOMER_DATA

Schema: FLATTEN_DATA

Name: CUSTOMER_FLATTEN 

Table structure

CUSTOMERID INT

NAME STRING

EMAIL STRING

REGION STRING

COUNTRY STRING

PRODUCTNAME STRING

PRODUCTBRAND STRING

CATEGORY STRING

QUANTITY INT

PRICEPERUNIT FLOAT

TOTALSALES FLOAT

PURCHASEMODE STRING

MODEOFPAYMENT STRING

PURCHASEDATE DATE





4. Upload the JSON File to an Internal Stage

Create an Internal Stage in the RAW_DATA schema

Database: CUSTOMER_DATA

Schema: RAW_DATA

Name: CUSTOMER_STAGE

Upload the customer json data file in the internal stage

List the file in the internal stage




5. Load Data from the Stage into the Raw Table

To load the raw customer data into the CUSTOMER_RAW table, use the COPY INTO command

 
6. Perform JSON flattening and insert data into the flatten table

Extract the required columns from the raw table and load into the flatten table by flattening the JSON data. Here we need to use the LATERAL FLATTEN functionality of snowflake

 

7. Data Analysis on the flatten data

 
Calculate the total sales for each region.

Identify the region with the highest total sales.

Determine the total quantity sold for each product brand.

Find the product with the least quantity sold.

Identify the customer who made the highest purchase.

Locate the product name and brand with the lowest unit price.

List the top 5 best-selling products.

Identify the 5 countries with the lowest sales.
