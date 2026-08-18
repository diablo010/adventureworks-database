create schema adventureworks_dw.gold;

-- fact_sales
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.FACT_SALES AS
SELECT
    d.sales_order_detail_id,
    h.sales_order_id,
    dp.product_key,
    dc.customer_key,
    h.order_date,
    d.order_qty,
    d.unit_price,
    d.unit_price_discount,
    d.order_qty * d.unit_price AS gross_sales,
    d.order_qty
        * d.unit_price
        * (1 - d.unit_price_discount) AS net_sales
FROM ADVENTUREWORKS_DW.SILVER.SALES_ORDER_DETAIL d
INNER JOIN ADVENTUREWORKS_DW.SILVER.SALES_ORDER_HEADER h
    ON d.sales_order_id = h.sales_order_id
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_PRODUCT dp
    ON d.product_id = dp.product_id
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_CUSTOMER dc
    ON h.customer_id = dc.customer_id;

-- fact_purchase
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.FACT_PURCHASE AS
SELECT
    d.purchase_order_detail_id,
    h.purchase_order_id,
    dp.product_key,
    dv.vendor_key,
    h.order_date,
    d.due_date,
    d.order_qty,
    d.unit_price,
    d.received_qty,
    d.rejected_qty,
    d.order_qty * d.unit_price AS purchase_amount,
    d.rejected_qty * d.unit_price AS rejected_amount
FROM ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_DETAIL d
INNER JOIN ADVENTUREWORKS_DW.SILVER.PURCHASE_ORDER_HEADER h
    ON d.purchase_order_id = h.purchase_order_id
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_PRODUCT dp
    ON d.product_id = dp.product_id
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_VENDOR dv
    ON h.vendor_id = dv.business_entity_id;

-- fact_work_order
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.FACT_WORK_ORDER AS
SELECT
    w.work_order_id,
    dp.product_key,
    w.start_date,
    w.end_date, 
    w.due_date,
    w.order_qty,
    w.scrapped_qty,
    DATEDIFF(
        'day',
        w.start_date,
        w.end_date
    ) AS production_days,
    CASE
        WHEN w.order_qty > 0
        THEN w.scrapped_qty / w.order_qty
        ELSE 0
    END AS scrap_rate
FROM ADVENTUREWORKS_DW.SILVER.WORK_ORDER w
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_PRODUCT dp
    ON w.product_id = dp.product_id;

-- fact_work_order_routing
CREATE OR REPLACE TABLE ADVENTUREWORKS_DW.GOLD.FACT_WORK_ORDER_ROUTING AS
SELECT
    r.work_order_id,
    r.operation_sequence,
    dp.product_key,
    dl.location_key,
    r.scheduled_start_date,
    r.scheduled_end_date,
    r.actual_start_date,
    r.actual_end_date,
    r.actual_resource_hours,
    r.planned_cost,
    r.actual_cost,
    r.actual_cost - r.planned_cost AS cost_variance,
    DATEDIFF(
        'hour',
        r.actual_start_date,
        r.actual_end_date
    ) AS actual_operation_hours
FROM ADVENTUREWORKS_DW.SILVER.WORK_ORDER_ROUTING r
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_PRODUCT dp
    ON r.product_id = dp.product_id
LEFT JOIN ADVENTUREWORKS_DW.GOLD.DIM_LOCATION dl
    ON r.location_id = dl.location_id;