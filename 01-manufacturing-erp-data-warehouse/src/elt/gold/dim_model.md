

```mermaid
flowchart LR
    dim_customer --> fact_sales
    dim_product --> fact_sales

    dim_vendor --> fact_purchase
    dim_product --> fact_purchase

    dim_product --> fact_work_order_routing
    dim_location --> fact_work_order_routing
    fact_work_order_routing --> dim_work_order

    dim_product --> fact_work_order
```
