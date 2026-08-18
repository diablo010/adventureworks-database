use schema adventureworks_dw.gold;

CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.DIM_PRODUCT AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY product_id
    ) AS product_key,      -- warehouse key; different from source-system key
    p.product_id,
    p.product_number,
    p.product_name,
    p.color,
    p.size,
    p.product_line,
    p.class,
    p.style,
    p.standard_cost,
    p.list_price,
    ps.product_subcategory_id,
    ps.subcategory_name,
    pc.product_category_id,
    pc.category_name
FROM ADVENTUREWORKS_DW.SILVER.PRODUCT p
LEFT JOIN ADVENTUREWORKS_DW.SILVER.PRODUCT_SUBCATEGORY ps
    ON p.product_subcategory_id = ps.product_subcategory_id
LEFT JOIN ADVENTUREWORKS_DW.SILVER.PRODUCT_CATEGORY pc
    ON ps.product_category_id = pc.product_category_id;

-- customer dimension
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.DIM_CUSTOMER AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY customer_id
    ) AS customer_key,      -- warehouse key; different from source-system key
    customer_id,
    person_id,
    store_id,
    territory_id
FROM ADVENTUREWORKS_DW.SILVER.CUSTOMER;

-- vendor dimension
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.DIM_VENDOR AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY business_entity_id
    ) AS vendor_key,
    business_entity_id,
    account_number,
    vendor_name,
    credit_rating,
    preferred_vendor_status,
    active_flag
FROM ADVENTUREWORKS_DW.SILVER.VENDOR;

-- location dimension
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.DIM_LOCATION AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY location_id
    ) AS location_key,
    location_id,
    location_name,
    availability
FROM ADVENTUREWORKS_DW.SILVER.LOCATION;