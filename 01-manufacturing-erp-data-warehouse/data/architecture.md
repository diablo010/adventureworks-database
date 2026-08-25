    AdventureWorks OLTP Database by Microsoft
                         │
                         ▼
                    PostgreSQL
                         │
                         ▼
                  Azure Blob Storage
                         │
                         ▼
                      Snowpipe
                         │
                         ▼
              ┌─────────────────────┐
              │ Snowflake BRONZE    │
              │ Raw ERP tables      │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Snowflake SILVER    │
              │ Cleaned/staged data │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Snowflake GOLD      │
              │ Facts + Dimensions  │
              └──────────┬──────────┘
                         │
     ┌───────────┌────────────┐──────────┐
     ▼           ▼            ▼          ▼
   Sales     Purchasing   Production   Cross-domain
Analytics    Analytics     Analytics    Analytics