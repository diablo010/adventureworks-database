-- creating silver schema in adventureworks_dw database
CREATE OR REPLACE SCHEMA ADVENTUREWORKS_DW.SILVER;

-- customer table
-- check duplicate keys
SELECT
    CUSTOMERID,
    COUNT(*) AS record_count
FROM ADVENTUREWORKS_DW.BRONZE.RAW_CUSTOMER
GROUP BY CUSTOMERID
HAVING COUNT(*) > 1;

-- null primary key
SELECT COUNT(*) AS null_customer_ids
FROM ADVENTUREWORKS_DW.BRONZE.RAW_CUSTOMER
WHERE CUSTOMERID IS NULL;

CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.CUSTOMER
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT CUSTOMERID :: NUMBER AS customer_id,
    PERSONID :: NUMBER  AS person_id,
    STOREID :: NUMBER  AS store_id,
    TERRITORYID :: NUMBER AS territory_id
FROM ADVENTUREWORKS_DW.BRONZE.RAW_CUSTOMER
WHERE CUSTOMERID IS NOT NULL;


-- salesorderheader table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_HEADER
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT salesorderid :: NUMBER AS sales_order_id,
    revisionnumber :: NUMBER as revision_number,
    orderdate :: DATE as order_date,
    duedate :: DATE as due_date,
    shipdate :: DATE as ship_date,
    status :: NUMBER as status,
    onlineorderflag :: BOOLEAN as online_order_flag,
    purchaseordernumber :: VARCHAR AS purchase_order_number,
    accountnumber :: VARCHAR AS account_number,
    customerid :: NUMBER AS customer_id,
    salespersonid :: NUMBER AS salesperson_id,
    territoryid :: NUMBER AS territory_id,
    billtoaddressid :: NUMBER AS bill_to_address_id,
    shiptoaddressid :: NUMBER AS ship_to_address_id,
    shipmethodid :: NUMBER AS ship_method_id,
    creditcardid :: NUMBER AS credit_card_id,
    creditcardapprovalcode :: VARCHAR AS credit_card_approval_code,
    currencyrateid :: NUMBER AS currency_rate_id,
    ROUND(subtotal, 2) :: DECIMAL(10, 2) as sub_total,
    ROUND(taxamt, 2) :: DECIMAL(10, 2) as tax_amount,
    ROUND(freight, 2) :: DECIMAL(10, 2) as freight,
    ROUND(totaldue, 2) :: DECIMAL(10, 2) as total_due
FROM ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERHEADER
WHERE salesorderid IS NOT NULL;


-- salesorderdetail table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_DETAIL
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT salesorderdetailid :: NUMBER AS SALES_ORDER_DETAIL_ID,
    salesorderid :: NUMBER AS SALES_ORDER_ID,
    carriertrackingnumber :: VARCHAR AS carrier_tracking_number,
    orderqty :: NUMBER AS order_qty,
    productid :: NUMBER AS product_id,
    specialofferid :: NUMBER AS special_offer_id,
	unitprice :: FLOAT AS unit_price,
    unitpricediscount :: FLOAT AS unit_price_discount
FROM ADVENTUREWORKS_DW.BRONZE.RAW_SALESORDERDETAIL
WHERE salesorderdetailid IS NOT NULL;


-- product table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    productid :: NUMBER AS product_id,
    name :: VARCHAR AS product_name,
    productnumber :: VARCHAR AS product_number,
    makeflag :: BOOLEAN AS make_flag,
    finishedgoodsflag :: BOOLEAN AS finished_goods_flag,
    color :: VARCHAR AS color,
    safetystocklevel :: NUMBER AS safety_stock_level,
    reorderpoint :: NUMBER AS reorder_point,
    standardcost :: FLOAT AS standard_cost,
    listprice :: FLOAT AS list_price,
    size :: VARCHAR AS size,
    sizeunitmeasurecode :: VARCHAR AS size_unit_measure_code,
    weightunitmeasurecode :: VARCHAR AS weight_unit_measure_code,
    weight :: VARCHAR AS weight,
    daystomanufacture :: NUMBER AS days_to_manufacture,
    productline :: VARCHAR AS product_line,
    class :: VARCHAR AS class,
    style :: VARCHAR AS style,
    productsubcategoryid :: NUMBER AS product_subcategory_id,
    productmodelid :: NUMBER AS product_model_id,
    sellstartdate :: DATE AS sell_start_date,
    sellenddate :: DATE AS sell_end_date,
    discontinueddate :: DATE AS discontinued_date
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCT
WHERE productid IS NOT NULL;


-- productcategory table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_CATEGORY
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    productcategoryid :: NUMBER AS product_category_id,
    name :: VARCHAR AS category_name
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCTCATEGORY
WHERE productcategoryid IS NOT NULL;


-- product_subcategory table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_SUBCATEGORY
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    productsubcategoryid :: NUMBER AS product_subcategory_id,
    productcategoryid :: NUMBER AS product_category_id,
    name :: VARCHAR AS subcategory_name
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCTSUBCATEGORY
WHERE productsubcategoryid IS NOT NULL;


-- product_inventory table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_INVENTORY
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    productid :: NUMBER AS product_id,
    locationid :: NUMBER AS location_id,
    shelf :: VARCHAR AS shelf,
    bin :: NUMBER AS bin,
    quantity :: NUMBER AS quantity
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PRODUCTINVENTORY
WHERE productid IS NOT NULL
  AND locationid IS NOT NULL;


-- purchaseorder_detail table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_DETAIL
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    purchaseorderdetailid :: NUMBER AS purchase_order_detail_id,
    purchaseorderid :: NUMBER AS purchase_order_id,
    duedate :: DATE AS due_date,
    orderqty :: NUMBER AS order_qty,
    productid :: NUMBER AS product_id,
    unitprice :: FLOAT AS unit_price,
    receivedqty :: NUMBER AS received_qty,
    rejectedqty :: NUMBER AS rejected_qty
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PURCHASEORDERDETAIL
WHERE purchaseorderdetailid IS NOT NULL;


-- vendor table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.VENDOR
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    businessentityid :: NUMBER AS business_entity_id,
    accountnumber :: VARCHAR AS account_number,
    name :: VARCHAR AS vendor_name,
    creditrating :: NUMBER AS credit_rating,
    preferredvendorstatus :: BOOLEAN AS preferred_vendor_status,
    activeflag :: BOOLEAN AS active_flag
FROM ADVENTUREWORKS_DW.BRONZE.RAW_VENDOR
WHERE businessentityid IS NOT NULL;


-- purchase_order_header table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_HEADER
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    purchaseorderid :: NUMBER AS purchase_order_id,
    revisionnumber :: NUMBER AS revision_number,
    status :: NUMBER AS status,
    employeeid :: NUMBER AS employee_id,
    vendorid :: NUMBER AS vendor_id,
    shipmethodid :: NUMBER AS ship_method_id,
    orderdate :: DATE AS order_date,
    duedate :: DATE AS due_date,
    subtotal :: FLOAT AS subtotal,
    taxamt :: FLOAT AS tax_amount,
    freight :: FLOAT AS freight
FROM ADVENTUREWORKS_DW.BRONZE.RAW_PURCHASEORDERHEADER
WHERE purchaseorderid IS NOT NULL;


-- work_order table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    workorderid :: NUMBER AS work_order_id,
    productid :: NUMBER AS product_id,
    orderqty :: NUMBER AS order_qty,
    scrappedqty :: NUMBER AS scrapped_qty,
    startdate :: DATE AS start_date,
    enddate :: DATE AS end_date,
    duedate :: DATE AS due_date,
    scrapreasonid :: NUMBER AS scrap_reason_id
FROM ADVENTUREWORKS_DW.BRONZE.RAW_WORKORDER
WHERE workorderid IS NOT NULL;


-- work_order_routing table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER_ROUTING
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    workorderid :: NUMBER AS work_order_id,
    productid :: NUMBER AS product_id,
    operationsequence :: NUMBER AS operation_sequence,
    locationid :: NUMBER AS location_id,
    scheduledstartdate :: DATE AS scheduled_start_date,
    scheduledenddate :: DATE AS scheduled_end_date,
    actualstartdate :: DATE AS actual_start_date,
    actualenddate :: DATE AS actual_end_date,
    actualresourcehrs :: FLOAT AS actual_resource_hours,
    plannedcost :: FLOAT AS planned_cost,
    actualcost :: FLOAT AS actual_cost
FROM ADVENTUREWORKS_DW.BRONZE.RAW_WORKORDERRouting
WHERE workorderid IS NOT NULL
  AND operationsequence IS NOT NULL;


-- bill_of_materials table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.BILL_OF_MATERIALS
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    billofmaterialsid :: NUMBER AS bill_of_material_id,
    productassemblyid :: NUMBER AS product_assembly_id,
    componentid :: NUMBER AS component_id,
    startdate :: DATE AS start_date,
    enddate :: DATE AS end_date,
    unitmeasurecode :: VARCHAR AS unit_measure_code,
    bomlevel :: NUMBER AS bom_level,
    perassemblyqty :: FLOAT AS per_assembly_qty
FROM ADVENTUREWORKS_DW.BRONZE.RAW_BILLOFMATERIALS
WHERE billofmaterialsid IS NOT NULL;


-- location table
CREATE OR REPLACE DYNAMIC TABLE ADVENTUREWORKS_DW.SILVER.LOCATION
TARGET_LAG = '10 minutes'
WAREHOUSE = COMPUTE_WH
REFRESH_MODE = INCREMENTAL
AS
SELECT
    DISTINCT
    locationid :: NUMBER AS location_id,
    name :: VARCHAR AS location_name,
    availability :: NUMBER AS availability
FROM ADVENTUREWORKS_DW.BRONZE.RAW_LOCATION
WHERE locationid IS NOT NULL;


-- creating PRIMARY KEYS
ALTER TABLE ADVENTUREWORKS_DW.SILVER.VENDOR
ADD PRIMARY KEY (business_entity_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.LOCATION
ADD PRIMARY KEY (location_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.CUSTOMER 
ADD PRIMARY KEY (customer_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_HEADER
ADD PRIMARY KEY (sales_order_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_DETAIL
ADD PRIMARY KEY (sales_order_detail_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT
ADD PRIMARY KEY (product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_CATEGORY
ADD PRIMARY KEY (product_category_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_SUBCATEGORY
ADD PRIMARY KEY (product_subcategory_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_INVENTORY
ADD PRIMARY KEY (product_id, location_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_DETAIL
ADD PRIMARY KEY (purchase_order_detail_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.BILL_OF_MATERIALS
ADD PRIMARY KEY (bill_of_material_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER_ROUTING
ADD PRIMARY KEY (work_order_id, operation_sequence) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER
ADD PRIMARY KEY (work_order_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_HEADER
ADD PRIMARY KEY (purchase_order_id) RELY;

-- creating FOREIGN KEYS
ALTER TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_HEADER
ADD FOREIGN KEY (vendor_id) REFERENCES vendor(business_entity_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER
ADD FOREIGN KEY (product_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER_ROUTING
ADD FOREIGN KEY (product_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER_ROUTING
ADD FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.WORK_ORDER_ROUTING
ADD FOREIGN KEY (location_id) REFERENCES location(location_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.BILL_OF_MATERIALS
ADD FOREIGN KEY (product_assembly_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.BILL_OF_MATERIALS
ADD FOREIGN KEY (component_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_DETAIL
ADD FOREIGN KEY (purchase_order_id) REFERENCES purchase_order_header(purchase_order_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_DETAIL
ADD FOREIGN KEY (product_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_INVENTORY
ADD FOREIGN KEY (product_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_INVENTORY
ADD FOREIGN KEY (location_id) REFERENCES location(location_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT_SUBCATEGORY
ADD FOREIGN KEY (product_category_id) REFERENCES product_category(product_category_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.PRODUCT
ADD FOREIGN KEY (product_subcategory_id) REFERENCES product_subcategory(product_subcategory_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_DETAIL
ADD FOREIGN KEY (sales_order_id) REFERENCES sales_order_header(sales_order_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_DETAIL
ADD FOREIGN KEY (product_id) REFERENCES product(product_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_HEADER
ADD FOREIGN KEY (territory_id) REFERENCES location(location_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.SALES_ORDER_HEADER
ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id) RELY;

ALTER TABLE ADVENTUREWORKS_DW.SILVER.CUSTOMER 
ADD FOREIGN KEY (territory_id) REFERENCES location(location_id) RELY;
