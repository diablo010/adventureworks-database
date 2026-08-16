-- CREATING TABLES IN SNOWFLAKE TO STORE CSVs (MAKE SURE COLUMN NAMES AND NUMBER MATCH)

-- raw_salesorderheader table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_salesorderheader (
    salesorderid NUMBER PRIMARY KEY,
    revisionnumber NUMBER,
    orderdate TIMESTAMP,
    duedate TIMESTAMP,
    shipdate TIMESTAMP,
    status NUMBER,
    onlineorderflag BOOLEAN,
    purchaseordernumber VARCHAR,
    accountnumber VARCHAR,
    customerid NUMBER REFERENCES raw_customer(customerid),
    salespersonid NUMBER,
    territoryid NUMBER,
    billtoaddressid NUMBER,
    shiptoaddressid NUMBER,
    totaldue FLOAT
);

-- salesorderdetail table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_salesorderdetail (
    salesorderid NUMBER REFERENCES raw_salesorderheader(salesorderid),
    salesorderdetailid NUMBER PRIMARY KEY,
    carriertrackingnumber VARCHAR,
    orderqty NUMBER,
    productid NUMBER  REFERENCES raw_product(productid),
    specialofferid NUMBER,
	unitprice  FLOAT,
    unitpricediscount FLOAT
);

-- customer table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_customer (
    customerid NUMBER PRIMARY KEY,
    personid NUMBER,
    storeid NUMBER,
    territoryid NUMBER
);

-- product table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_product (
    productid NUMBER PRIMARY KEY,
    name VARCHAR,
    productnumber VARCHAR,
    makeflag BOOLEAN,
    finishedgoodsflag BOOLEAN,
    color VARCHAR,
    safetystocklevel NUMBER,
    reorderpoint NUMBER,
    standardcost FLOAT,
    listprice FLOAT,
    size VARCHAR,
    sizeunitmeasurecode VARCHAR,
    weightunit VARCHAR,
    weight NUMBER,
    daystomanufacture NUMBER,
    style VARCHAR,
    productsubcategoryid NUMBER,
    productmodelid NUMBER
);

-- displays tables from schema
SHOW TABLES IN SCHEMA adventureworks_dw.bronze;
