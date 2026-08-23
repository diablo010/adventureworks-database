-- Revenue & Growth

-- quarterly sales 
select 
    date_trunc('quarter', order_date) as quarter_bucket,
    round(sum(gross_sales), 2) as total_gross_sales,
    count(order_qty) as total_qty
from adventureworks_dw.gold.fact_sales
group by quarter_bucket
order by quarter_bucket;

-- percentage sales growth compared to previous quarter
select 
    date_trunc('quarter', order_date) as quarter_bucket,
    sum(gross_sales) as total_gross_sales,
    lag(sum(gross_sales)) OVER (ORDER BY quarter_bucket) AS previous_quarter_gross_sales,
    round(sum(gross_sales) - LAG(sum(gross_sales)) OVER (ORDER BY quarter_bucket), 2) AS gross_sales_change
from adventureworks_dw.gold.fact_sales
group by quarter_bucket
order by quarter_bucket;

-- total revenue by subcategory
select 
    dp.product_subcategory_id,
    dp.subcategory_name,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
left join adventureworks_dw.gold.dim_product dp
on fs.product_key = dp.product_key
group by dp.product_subcategory_id, dp.subcategory_name
order by dp.product_subcategory_id, dp.subcategory_name;

-- revenue by customer
select 
    fs.customer_key,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
group by fs.customer_key
order by fs.customer_key;

-- revenue by territory
select 
    dc.territory_id,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
left join adventureworks_dw.gold.dim_customer dc
group by dc.territory_id
order by dc.territory_id;

