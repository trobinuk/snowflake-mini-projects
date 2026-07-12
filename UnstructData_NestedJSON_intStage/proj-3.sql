CREATE DATABASE SALES_DATA;

USE SALES_DATA;

CREATE SCHEMA RAW_DATA;

CREATE SCHEMA FLATTEN_DATA;

USE SALES_DATA.RAW_DATA;

CREATE TABLE SALES_RAW
(
JSON_DATA VARIANT
);

USE SALES_DATA.FLATTEN_DATA;

CREATE TABLE SALES_FLATTEN
(
COMPANIES STRING,
SALES_PERIOD STRING,
TOTAL_REVENUE FLOAT,
TOTAL_UNITS_SOLD FLOAT,
REGIONS STRING,
TOTAL_SALES FLOAT,
PRODUCTS STRING,
UNITS_SOLD FLOAT,
REVENUE FLOAT
);

USE SALES_DATA.RAW_DATA;

CREATE OR REPLACE STAGE SALES_STAGE;

LIST @SALES_STAGE;

COPY INTO SALES_RAW
FROM @SALES_STAGE
FILE_FORMAT = (TYPE = 'JSON');

INSERT INTO SALES_DATA.FLATTEN_DATA.SALES_FLATTEN
(
COMPANIES,
SALES_PERIOD,
TOTAL_REVENUE,
TOTAL_UNITS_SOLD,
REGIONS,
TOTAL_SALES,
PRODUCTS,
UNITS_SOLD,
REVENUE 
)
SELECT --json_data:total_sales::float AS total_sales, 
        --json_data:total_units_sold::float AS total_units_sold,
        companies.key::string AS companies,
        companies.value:sales_period::string company_sales_period,
        companies.value:total_revenue::string company_total_revenue,
        companies.value:total_units_sold::string company_total_units_sold, 
        companies_region.key::string AS company_region,
        companies_region.value:total_sales::float AS company_region_total_sales,
        companies_region_products.key::string AS company_region_product,
        companies_region_products.value:units_sold::float AS company_region_prod_unit_sold,
        companies_region_products.value:revenue::float AS company_region_prod_rev
        
FROM SALES_RAW,
LATERAL FLATTEN (INPUT => json_data:companies) AS companies,
LATERAL FLATTEN (INPUT => companies.value:regions) AS companies_region,
LATERAL FLATTEN (INPUT => companies_region.value:products) AS companies_region_products--,
--LATERAL FLATTEN (INPUT => companies_region.value) AS companies_region1;

SELECT *
FROM SALES_DATA.FLATTEN_DATA.SALES_FLATTEN;

SELECT *
FROM (SELECT COMPANIES,
        TOTAL_REVENUE,
        ROW_NUMBER() OVER (ORDER BY TOTAL_REVENUE DESC) rn 
FROM  (SELECT DISTINCT 
        COMPANIES,
        TOTAL_REVENUE
FROM SALES_DATA.FLATTEN_DATA.SALES_FLATTEN))
WHERE rn <= 3;