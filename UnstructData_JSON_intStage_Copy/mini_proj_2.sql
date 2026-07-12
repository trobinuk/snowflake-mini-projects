CREATE DATABASE CUSTOMER_DATA;

USE CUSTOMER_DATA;

CREATE SCHEMA RAW_DATA;

CREATE SCHEMA FLATTEN_DATA;

USE CUSTOMER_DATA.RAW_DATA;

CREATE TABLE CUSTOMER_RAW
(
JSON_DATA VARIANT
);

USE CUSTOMER_DATA.FLATTEN_DATA;

CREATE TABLE CUSTOMER_FLATTEN
(
CUSTOMERID INT,
NAME STRING,
EMAIL STRING,
REGION STRING,
COUNTRY STRING,
PRODUCTNAME STRING,
PRODUCTBRAND STRING,
CATEGORY STRING,
QUANTITY INT,
PRICEPERUNIT FLOAT,
TOTALSALES FLOAT,
PURCHASEMODE STRING,
MODEOFPAYMENT STRING,
PURCHASEDATE DATE
);

USE CUSTOMER_DATA.RAW_DATA;

CREATE OR REPLACE STAGE CUSTOMER_STAGE;

LIST @CUSTOMER_STAGE;

COPY INTO CUSTOMER_RAW
FROM @CUSTOMER_STAGE
FILE_FORMAT = (TYPE = 'JSON');

SELECT json_data
FROM CUSTOMER_DATA.RAW_DATA.CUSTOMER_RAW;

INSERT INTO CUSTOMER_DATA.FLATTEN_DATA.CUSTOMER_FLATTEN
(
    CUSTOMERID,
    NAME,
    EMAIL,
    REGION,
    COUNTRY,
    PRODUCTNAME,
    PRODUCTBRAND,
    CATEGORY,
    QUANTITY,
    PRICEPERUNIT,
    TOTALSALES,
    PURCHASEMODE,
    MODEOFPAYMENT,
    PURCHASEDATE 
)
SELECT      
       data1.value:customerid::integer AS customerid,
       data1.value:name::string AS name,
       data1.value:email::string AS email,
       data1.value:region::string AS region,
       data1.value:country::string AS country,
       data1.value:productname::string AS productname,
       data1.value:productbrand::string AS productbrand,
       data1.value:category::string AS category, 
       data1.value:quantity::integer AS quantity,
       data1.value:priceperunit::float AS priceperunit,
       data1.value:totalsales::float AS totalsales,
       data1.value:purchasemode::string AS purchasemode,
       data1.value:modeofpayment::string AS modeofpayment,
       CAST(data1.value:purchasedate::string AS DATE) AS purchasedate
FROM CUSTOMER_DATA.RAW_DATA.CUSTOMER_RAW,
LATERAL FLATTEN (INPUT => json_data) AS data1;

USE CUSTOMER_DATA.FLATTEN_DATA;

SELECT *
FROM CUSTOMER_FLATTEN

--Calculate the total sales for each region.
SELECT region,
        SUM(totalsales) AS totalsales
FROM CUSTOMER_FLATTEN
GROUP BY region;

--Identify the region with the highest total sales.
SELECT region,
        totalsales
FROM (SELECT region,
        SUM(totalsales) AS totalsales,
        ROW_NUMBER() OVER (ORDER BY SUM(totalsales) DESC) rn 
FROM CUSTOMER_FLATTEN
GROUP BY region)
WHERE rn = 1;

--Determine the total quantity sold for each product brand.
SELECT PRODUCTBRAND,
        SUM(QUANTITY) AS QUANTITY
FROM CUSTOMER_FLATTEN
GROUP BY PRODUCTBRAND;


--Find the product with the least quantity sold.
SELECT PRODUCTNAME,
        QUANTITY
FROM (SELECT PRODUCTNAME,
        SUM(QUANTITY) AS QUANTITY,
        ROW_NUMBER() OVER (ORDER BY SUM(QUANTITY)) rn 
FROM CUSTOMER_FLATTEN
GROUP BY PRODUCTNAME)
WHERE rn = 1;

--Identify the customer who made the highest purchase.

--Locate the product name and brand with the lowest unit price.

--List the top 5 best-selling products.

--Identify the 5 countries with the lowest sales.