-- Purchasing

-- 1. Monthly purchase spend
select 
    date_trunc('month', order_date) as month_bucket,
    round(sum(purchase_amount), 2) as total_purchases,
from adventureworks_dw.gold.fact_purchase
group by month_bucket
order by month_bucket;

-- 2. Top suppliers by purchase spend
select 
    dv.vendor_key,
    dv.vendor_name,
    cast(sum(fp.purchase_amount) as decimal(15, 2)) as total_purchases,
from adventureworks_dw.gold.fact_purchase fp
left join adventureworks_dw.gold.dim_vendor dv
on fp.vendor_key = dv.vendor_key
group by dv.vendor_key, dv.vendor_name
order by total_purchases desc
limit 10;

-- 3. Purchase spend by product category
select 
    dp.product_category_id,
    dp.category_name,
    cast(sum(fp.purchase_amount) as decimal(15, 2)) as total_purchases,
from adventureworks_dw.gold.fact_purchase fp
left join adventureworks_dw.gold.dim_product dp
on fp.product_key = dp.product_key
where dp.product_category_id is not null
group by dp.product_category_id, dp.category_name
order by dp.product_category_id;

-- 4. Products with highest purchase cost
select 
    dp.product_category_id,
    dp.product_name,
    cast(fp.purchase_amount as decimal(15, 2)) as purchase_amount,
from adventureworks_dw.gold.fact_purchase fp
left join adventureworks_dw.gold.dim_product dp
on fp.product_key = dp.product_key
order by purchase_amount desc
limit 10;

-- 5. Supplier contribution to total purchase spend
with vendor_contribution as (
    select 
        dv.vendor_key,
        sum(fp.purchase_amount) as total_vendor_purchase,
    from adventureworks_dw.gold.fact_purchase fp
    left join adventureworks_dw.gold.dim_vendor dv
    on fp.vendor_key = dv.vendor_key
    group by dv.vendor_key
    order by vendor_key
)
select vendor_key, 
    round(100 * total_vendor_purchase / 
        (select sum(purchase_amount) 
            from adventureworks_dw.gold.fact_purchase)
    , 3) as supplier_contribution
from vendor_contribution;