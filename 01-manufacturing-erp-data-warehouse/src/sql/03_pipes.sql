-- CREATING PIPES FOR EACH TABLE

-- salesorderheader_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.salesorderheader_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_salesorderheader
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/sales/salesorderheader/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);

-- salesorderdetail pipe 
CREATE OR REPLACE PIPE ADVENTUREWORKS_DW.BRONZE.SALESORDERDETAIL_PIPE
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERDETAIL
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/sales/salesorderdetail/
FILE_FORMAT = (
    FORMAT_NAME = ADVENTUREWORKS_DW.BRONZE.CSV_FORMAT
);

-- customer pipe
CREATE OR REPLACE PIPE ADVENTUREWORKS_DW.BRONZE.CUSTOMER_PIPE
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO ADVENTUREWORKS_DW.BRONZE.RAW_CUSTOMER
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/sales/customer/
FILE_FORMAT = (
    FORMAT_NAME = ADVENTUREWORKS_DW.BRONZE.CSV_FORMAT
);

-- product pipe
CREATE OR REPLACE PIPE ADVENTUREWORKS_DW.BRONZE.PRODUCT_PIPE
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCT
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/product/
FILE_FORMAT = (
    FORMAT_NAME = ADVENTUREWORKS_DW.BRONZE.CSV_FORMAT
);

-- productsubcategory_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.productsubcategory_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_productsubcategory
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/productsubcategory/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- productcategory_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.productcategory_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_productcategory
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/productcategory/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- workorder_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.workorder_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_workorder
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/workorder/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- workorderrouting_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.workorderrouting_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_workorderrouting
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/workorderrouting/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- billofmaterials_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.billofmaterials_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_billofmaterials
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/billofmaterials/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- productinventory_pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.productinventory_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_productinventory
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/productinventory/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- location pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.location_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_location
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/production/location/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- purchaseorderheader pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.purchaseorderheader_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_purchaseorderheader
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/purchasing/purchaseorderheader/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- purchaseorderdetail pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.purchaseorderdetail_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_purchaseorderdetail
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/purchasing/purchaseorderdetail/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);

-- vendor pipe
CREATE OR REPLACE PIPE adventureworks_dw.bronze.vendor_pipe
    AUTO_INGEST = TRUE
    INTEGRATION = 'AZURE_SNOWPIPE_INT'
AS
COPY INTO adventureworks_dw.bronze.raw_vendor
FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/purchasing/vendor/
FILE_FORMAT = (
    FORMAT_NAME = adventureworks_dw.bronze.csv_format
);


-- displays pipes from schema
SHOW PIPES IN SCHEMA adventureworks_dw.bronze;

-- checks stats of pipe(running, pendingFileCount, etc.)
SELECT SYSTEM$PIPE_STATUS(
    'ADVENTUREWORKS_DW.BRONZE.SALESORDERHEADER_PIPE'
);

SELECT SYSTEM$PIPE_STATUS(
    'ADVENTUREWORKS_DW.BRONZE.SALESORDERDETAIL_PIPE'
);

SELECT SYSTEM$PIPE_STATUS(
    'ADVENTUREWORKS_DW.BRONZE.CUSTOMER_PIPE'
);

SELECT SYSTEM$PIPE_STATUS(
    'ADVENTUREWORKS_DW.BRONZE.PRODUCT_PIPE'
);

-- manual way of loading data into tables from stage
-- COPY INTO ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERHEADER
-- FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE
-- FILE_FORMAT = (
--     FORMAT_NAME = ADVENTUREWORKS_DW.BRONZE.CSV_FORMAT
-- );

-- lists ingested files from azure blob to stage
LIST @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/;
LIST @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/sales/;
LIST @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE/sales/customer/;


-- copy history of uploaded csvs to tables
SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME => 'ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERHEADER',
        START_TIME => DATEADD('hour', -2, CURRENT_TIMESTAMP())
    )
)
ORDER BY LAST_LOAD_TIME DESC;

SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME => 'ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCT',
        START_TIME => DATEADD('hour', -2, CURRENT_TIMESTAMP())
    )
)
ORDER BY LAST_LOAD_TIME DESC;

-- processes any missed files
ALTER PIPE ADVENTUREWORKS_DW.BRONZE.SALESORDERHEADER_PIPE REFRESH;

ALTER PIPE ADVENTUREWORKS_DW.BRONZE.SALESORDERDETAIL_PIPE REFRESH;

ALTER PIPE ADVENTUREWORKS_DW.BRONZE.CUSTOMER_PIPE REFRESH;

ALTER PIPE ADVENTUREWORKS_DW.BRONZE.PRODUCT_PIPE REFRESH;

-- select commands to ensure data is loaded into tables
SELECT *
FROM ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERHEADER;

SELECT *
FROM ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERDETAIL;

SELECT *
FROM ADVENTUREWORKS_DW.BRONZE.RAW_CUSTOMER;

SELECT *
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCT;

-- miscellaneous commands
SHOW PIPES IN SCHEMA ADVENTUREWORKS_DW.BRONZE;
DESC PIPE ADVENTUREWORKS_DW.BRONZE.PRODUCT_PIPE;

-- CAN BE USED TO VALIDATE ERRORS: In above size was assigned number but, in data, it was varchar
-- COPY INTO ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCT
-- FROM @ADVENTUREWORKS_DW.BRONZE.ADVENTUREWORKS_BRONZE_STAGE;
