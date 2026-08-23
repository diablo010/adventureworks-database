-- Sales 

-- 1. Quarterly sales 
select 
    date_trunc('quarter', order_date) as quarter_bucket,
    round(sum(gross_sales), 2) as total_gross_sales,
    count(order_qty) as total_qty
from adventureworks_dw.gold.fact_sales
group by quarter_bucket
order by quarter_bucket;

-- 2. Quarter-over-quarter revenue growth
select 
    date_trunc('quarter', order_date) as quarter_bucket,
    sum(gross_sales) as total_gross_sales,
    lag(sum(gross_sales)) OVER (ORDER BY quarter_bucket) AS previous_quarter_gross_sales,
    round(sum(gross_sales) - LAG(sum(gross_sales)) OVER (ORDER BY quarter_bucket), 2) AS gross_sales_change
from adventureworks_dw.gold.fact_sales
group by quarter_bucket
order by quarter_bucket;

-- 3. Month-over-month revenue growth
select 
    date_trunc('month', order_date) as month_bucket,
    sum(gross_sales) as total_gross_sales,
    lag(sum(gross_sales)) OVER (ORDER BY month_bucket) AS previous_month_gross_sales,
    round(sum(gross_sales) - LAG(sum(gross_sales)) OVER (ORDER BY month_bucket), 2) AS gross_sales_change
from adventureworks_dw.gold.fact_sales
group by month_bucket
order by month_bucket;

-- 4. Total revenue by subcategory
select 
    dp.product_subcategory_id,
    dp.subcategory_name,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
left join adventureworks_dw.gold.dim_product dp
on fs.product_key = dp.product_key
group by dp.product_subcategory_id, dp.subcategory_name
order by dp.product_subcategory_id, dp.subcategory_name;

-- 5. Revenue by customer
select 
    fs.customer_key,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
group by fs.customer_key
order by fs.customer_key;

-- 6. Revenue by territory
select 
    dc.territory_id,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
left join adventureworks_dw.gold.dim_customer dc
group by dc.territory_id
order by dc.territory_id;

-- 7. Top 10 products by revenue
select 
    dp.product_category_id,
    dp.category_name,
    dp.product_name,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
left join adventureworks_dw.gold.dim_product dp
on fs.product_key = dp.product_key
group by dp.product_category_id, dp.category_name, dp.product_name
order by total_revenue desc
limit 10;

-- 8. Top customers by revenue
select 
    dc.customer_key,
    sum(net_sales) as total_revenue
from adventureworks_dw.gold.fact_sales fs
left join adventureworks_dw.gold.dim_customer dc
on fs.customer_key = dc.customer_key
group by dc.customer_key
order by total_revenue desc
limit 10;

-- 9. Top 3 products by category
with top3_products as (
  select
    dp.category_name, 
    dp.product_name, 
    round(sum(fs.net_sales), 2) as total_revenue,
    row_number() over (
      partition by dp.category_name 
      order by total_revenue desc
    ) as rank
  from adventureworks_dw.gold.fact_sales fs
  left join adventureworks_dw.gold.dim_product dp
  on fs.product_key = dp.product_key
  group by dp.category_name, dp.product_name
)
select category_name, product_name, total_revenue
from top3_products
where rank <= 3;
