-- Cross-domain

-- 1. Revenue vs purchase cost by product
with revenue_by_product as (
    select fs.product_key, sum(net_sales) as total_revenue
    from adventureworks_dw.gold.fact_sales fs
    left join adventureworks_dw.gold.dim_product dp
    on fs.product_key = dp.product_key
    group by fs.product_key
),
purchase_by_product as (
    select fp.product_key, sum(purchase_amount) as total_purchase
    from adventureworks_dw.gold.fact_purchase fp
    left join adventureworks_dw.gold.dim_product dp
    on fp.product_key = dp.product_key
    group by fp.product_key
)
select rp.product_key,
       round(total_purchase / total_revenue, 2) as purchase_to_revenue_ratio
from revenue_by_product rp
left join purchase_by_product pp
on rp.product_key = pp.product_key
where purchase_to_revenue_ratio is not null;

-- 2. Gross profit and margin by product
with total_sales as (
    select fs.product_key, sum(fs.gross_sales) as total_sales
    from adventureworks_dw.gold.fact_sales fs
    left join adventureworks_dw.gold.dim_product dp
    on fs.product_key = dp.product_key
    group by fs.product_key
),
total_purchases as (
    select fp.product_key, sum(fp.purchase_amount) as total_purchase
    from adventureworks_dw.gold.fact_purchase fp
    left join adventureworks_dw.gold.dim_product dp
    on fp.product_key = dp.product_key
    group by fp.product_key
)
select 
       s.product_key,
       s.total_sales,
       round(s.total_sales - p.total_purchase, 2) as gross_profit,
       round(100 * gross_profit / s.total_sales, 2) as "gross_margin(%)"
from total_sales s
left join total_purchases p
on s.product_key = p.product_key
where gross_profit is not null
order by gross_profit desc;

-- 3. Products with high sales but low production
with total_sales as (
    select fs.product_key, sum(fs.gross_sales) as total_sales
    from adventureworks_dw.gold.fact_sales fs
    left join adventureworks_dw.gold.dim_product dp
    on fs.product_key = dp.product_key
    group by fs.product_key
),
total_qty as (
    select fwo.product_key, sum(fwo.order_qty) as total_order_qty
    from adventureworks_dw.gold.fact_work_order fwo
    left join adventureworks_dw.gold.dim_product dp
    on fwo.product_key = dp.product_key
    group by fwo.product_key
)
select 
       s.product_key,
       s.total_sales,
       q.total_order_qty,
       round(s.total_sales / q.total_order_qty , 2) as sales_qty_ratio,
from total_sales s
left join total_qty q
on s.product_key = q.product_key
where s.total_sales is not null and q.total_order_qty is not null
order by sales_qty_ratio desc
limit 50;

-- 4. Products with high production but low sales
with total_sales as (
    select fs.product_key, sum(fs.gross_sales) as total_sales
    from adventureworks_dw.gold.fact_sales fs
    left join adventureworks_dw.gold.dim_product dp
    on fs.product_key = dp.product_key
    group by fs.product_key
),
total_qty as (
    select fwo.product_key, sum(fwo.order_qty) as total_order_qty
    from adventureworks_dw.gold.fact_work_order fwo
    left join adventureworks_dw.gold.dim_product dp
    on fwo.product_key = dp.product_key
    group by fwo.product_key
)
select 
       s.product_key,
       q.total_order_qty,
       s.total_sales,
       round(q.total_order_qty / s.total_sales, 2) as qty_sales_ratio,
from total_sales s
left join total_qty q
on s.product_key = q.product_key
where s.total_sales is not null and q.total_order_qty is not null
order by qty_sales_ratio desc
limit 50;

-- 22. Revenue, purchase spend and production volume by month
with total_sales as (
    select date_trunc('month', order_date) as month_bucket, 
    sum(fs.gross_sales) as total_sales
    from adventureworks_dw.gold.fact_sales fs
    group by month_bucket
),
total_purchase as (
    select date_trunc('month', order_date) as month_bucket,
    sum(fp.purchase_amount) as total_purchase
    from adventureworks_dw.gold.fact_purchase fp
    group by month_bucket
),
total_production as (
    select date_trunc('month', end_date) as month_bucket,
    sum(fwo.order_qty) as total_production
    from adventureworks_dw.gold.fact_work_order fwo
    group by month_bucket
)
select 
       s.month_bucket,
       s.total_sales,
       p.total_purchase,
       pr.total_production
from total_sales s
left join total_purchase p
on s.month_bucket = p.month_bucket
left join total_production pr
on p.month_bucket = pr.month_bucket
order by s.month_bucket desc;
