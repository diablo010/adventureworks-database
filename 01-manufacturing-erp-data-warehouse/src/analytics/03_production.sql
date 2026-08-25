-- Production

-- 1. Monthly work-order volume
select 
    date_trunc('month', end_date) as month_bucket,
    sum(order_qty) - sum(scrapped_qty) as net_order_qty
from adventureworks_dw.gold.fact_production
group by month_bucket
order by month_bucket;

-- 2. Production quantity by product
select  
    dp.product_name,
    sum(order_qty) as gross_order_qty
from adventureworks_dw.gold.fact_work_order fwo
left join adventureworks_dw.gold.dim_product dp
on fwo.product_key = dp.product_key
group by dp.product_name
order by dp.product_name;

-- 3. Production quantity by location
select  
    dl.location_name,
    sum(fwo.order_qty) as gross_order_qty
from adventureworks_dw.gold.fact_work_order fwo
left join adventureworks_dw.gold.fact_work_order_routing fwor
on fwo.work_order_id = fwor.work_order_id
left join adventureworks_dw.gold.dim_location dl
on fwor.location_key = dl.location_key
group by dl.location_name;

-- 4. Average work-order duration
select round(avg(production_days), 2)  as avg_production_days
from adventureworks_dw.gold.fact_work_order;

-- 5. Products with highest production volume
select dp.product_key, dp.product_name,
       sum(order_qty) as total_order_qty
from adventureworks_dw.gold.fact_work_order fwo
left join adventureworks_dw.gold.dim_product dp
on fwo.product_key = dp.product_key
group by dp.product_key, dp.product_name
order by total_order_qty desc
limit 10;