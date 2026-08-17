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
    territoryid NUMBER REFERENCES raw_location(locationid),
    billtoaddressid NUMBER,
    shiptoaddressid NUMBER,
    shipmethodid NUMBER,
    creditcardid NUMBER,
    creditcardapprovalcode VARCHAR,
    currencyrateid NUMBER,
    subtotal FLOAT,
    taxamt FLOAT,
    freight FLOAT,
    totaldue FLOAT
);

-- salesorderdetail table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_salesorderdetail (
    salesorderid NUMBER REFERENCES raw_salesorderheader(salesorderid),
    salesorderdetailid NUMBER PRIMARY KEY,
    carriertrackingnumber VARCHAR,
    orderqty NUMBER,
    productid NUMBER REFERENCES raw_product(productid),
    specialofferid NUMBER,
	unitprice  FLOAT,
    unitpricediscount FLOAT
);

-- customer table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_customer (
    customerid NUMBER PRIMARY KEY,
    personid NUMBER,
    storeid NUMBER,
    territoryid NUMBER ReFERENCES raw_location(locationid)
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
    weightunitmeasurecode VARCHAR,
    weight VARCHAR,
    daystomanufacture NUMBER,
    productline VARCHAR,
    class VARCHAR,
    style VARCHAR,
    productsubcategoryid NUMBER REFERENCES raw_productsubcategory(productsubcategoryid),
    productmodelid NUMBER,
    sellstartdate DATE,
    sellenddate DATE,
    discontinueddate DATE
);

-- PRODUCTCATEGORY table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_productcategory (
    productcategoryid NUMBER PRIMARY KEY,
    name VARCHAR
);

-- productinventory table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_productinventory (
    productid NUMBER REFERENCES raw_product(productid),
    locationid NUMBER references raw_location(locationid),
    shelf VARCHAR,
    bin NUMBER,
    quantity NUMBER
);

-- productsubcategory table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_productsubcategory (
    productsubcategoryid NUMBER PRIMARY KEY,
    productcategoryid NUMBER REFERENCES raw_productcategory(productcategoryid),
    name VARCHAR
);

-- purchaseorderdetail table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_purchaseorderdetail (
    purchaseorderid NUMBER REFERENCES raw_purchaseorderheader(purchaseorderid),
    purchaseorderdetailid NUMBER PRIMARY KEY,
    duedate DATE,
    orderqty NUMBER,
    productid NUMBER REFERENCES raw_product(productid),
    unitprice FLOAT,
    receivedqty NUMBER,
    rejectedqty NUMBER
);

-- vendor table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_vendor (
    businessentityid NUMBER PRIMARY KEY,
    accountnumber VARCHAR,
    name VARCHAR,
    creditrating NUMBER,
    preferredvendorstatus BOOLEAN,
    activeflag BOOLEAN
);

-- purchaseorderheader table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_purchaseorderheader (
    purchaseorderid NUMBER PRIMARY KEY,
    revisionnumber NUMBER,
    status NUMBER,
    employeeid NUMBER,
    vendorid NUMBER REFERENCES raw_vendor(businessentityid),
    shipmethodid NUMBER,
    orderdate DATE,
    duedate DATE,
    subtotal FLOAT,
    taxamt FLOAT,
    freight FLOAT
);

-- workorder table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_workorder (
    workorderid NUMBER PRIMARY KEY,
    productid NUMBER REFERENCES raw_product(productid),
    orderqty NUMBER,
    scrappedqty NUMBER,
    startdate DATE,
    enddate DATE,
    duedate DATE,
    scrapreasonid NUMBER
);

-- workorderrouting table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_workorderrouting (
    workorderid NUMBER REFERENCES raw_workorder(workorderid),
    productid NUMBER REFERENCES raw_product(productid),
    operationsequence NUMBER,
    locationid NUMBER references raw_location(locationid),
    scheduledstartdate DATE,
    scheduledenddate DATE,
    actualstartdate DATE,
    actualenddate DATE,
    actualresourcehrs FLOAT,
    plannedcost FLOAT,
    actualcost FLOAT
);

-- billofmaterials table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_billofmaterials ( 
    billofmaterialsid NUMBER PRIMARY KEY,
    productassemblyid NUMBER REFERENCES raw_product(productid),
    componentid NUMBER REFERENCES raw_product(productid),
    startdate DATE,
    enddate DATE,
    unitmeasurecode VARCHAR,
    bomlevel NUMBER,
    perassemblyqty FLOAT
);

-- location table
CREATE OR REPLACE TABLE adventureworks_dw.bronze.raw_location (
    locationid NUMBER PRIMARY KEY,
    name VARCHAR,
    availability NUMBER
);

-- displays tables from schema
SHOW TABLES IN SCHEMA adventureworks_dw.bronze;

