CREATE DATABASE PRODUCT_DB;

USE PRODUCT_DB;

CREATE SCHEMA PRODUCT_DATA;

USE PRODUCT_DB.PRODUCT_DATA;

--CREATE SCHEMA FLATTEN_DATA;
CREATE TABLE PRODUCT_SRC
(
PRODUCTID STRING,
PRODUCTNAME STRING,
CATEGORY STRING,
PRICE FLOAT,
STOCKQUANTITY FLOAT,
SUPPLIER STRING,
RATING FLOAT
);

CREATE TABLE PRODUCT_TGT
(
PRODUCTID STRING,
PRODUCTNAME STRING,
CATEGORY STRING,
PRICE FLOAT,
STOCKQUANTITY FLOAT,
SUPPLIER STRING,
RATING FLOAT
);

SELECT * FROM product_src;

-- Stream Change log for data, metadata$action(insert,update,delete), metadata$isupdate(true, false), metadata$rowid (unique row identifier, external tables, views)
-- Standard Stream, Append-only Stream (track only inserts), Insert-Only Stream (only for external tables)

CREATE OR REPLACE STREAM product_stream ON TABLE product_src;

SELECT * FROM product_stream;

--Tasks let you run SQL on schedule
-- schedule, warehouse, code, condition
-- user-managed, serverless (USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE)

CREATE TASK product_task
SCHEDULE='1 MINUTE'
WAREHOUSE=COMPUTE_WH
AS
MERGE INTO product_tgt AS target
USING product_stream AS source
ON target.productid = source.productid
WHEN MATCHED THEN
UPDATE SET
    target.PRODUCTID = source.PRODUCTID,
    PRODUCTNAME = source.PRODUCTNAME,
    CATEGORY = source.CATEGORY,
    PRICE = source.PRICE,
    STOCKQUANTITY = source.STOCKQUANTITY,
    SUPPLIER = source.SUPPLIER,
    RATING = source.RATING
WHEN NOT MATCHED THEN
INSERT (PRODUCTID,PRODUCTNAME,CATEGORY,PRICE,STOCKQUANTITY,SUPPLIER,RATING)
VALUES (
PRODUCTID,PRODUCTNAME,CATEGORY,PRICE,STOCKQUANTITY,SUPPLIER,RATING);

SHOW TASKS;

ALTER TASK product_task RESUME;

SELECT * FROM TABLE (INFORMATION_SCHEMA.TASK_HISTORY(TASK_NAME => 'product_task'))

CREATE OR REPLACE STAGE product_stage;

LIST @product_stage;

COPY INTO product_src
FROM @product_stage/
FILES = ('product_changedata.csv')
PATTERN = 'product_stage/product_c.*'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER=1)
ON_ERROR = 'SKIP_FILE'; --'SKIP_FILE', 'SKIP_FILE_5', SKIP_FILE_5%, 'CONTINUE'

-- Account history, validation_mode, query_id

ALTER TASK product_task SUSPEND;

SELECT * FROM product_tgt;

SELECT * FROM product_src;


