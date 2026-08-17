                  AdventureWorks ERP
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
              ┌──────────┼──────────┐
              ▼          ▼          ▼
            Sales     Inventory   Production
             Mart        Mart        Mart