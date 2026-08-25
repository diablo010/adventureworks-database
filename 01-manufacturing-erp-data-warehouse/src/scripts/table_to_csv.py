import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path

engine = create_engine(
    "postgresql+psycopg2://postgres:<password>@localhost:5432/adventure_works"
)

PROJECT_ROOT = Path(__file__).resolve().parents[2] # resolve() -> gives absolute path   # .parents[2] -> 01-manufacturing
OUTPUT_DIR = PROJECT_ROOT / "data" / "extracted"

sales_output_dir = OUTPUT_DIR / "sales"
sales_output_dir.mkdir(parents=True, exist_ok=True)

purchasing_output_dir = OUTPUT_DIR / "purchasing"
purchasing_output_dir.mkdir(parents=True, exist_ok=True)

production_output_dir = OUTPUT_DIR / "production"
production_output_dir.mkdir(parents=True, exist_ok=True)

sales_tables = {
    "sales.salesorderheader": "salesorderheader",
    "sales.salesorderdetail": "salesorderdetail",
    "sales.customer": "customer"
}

purchasing_tables = {
    "purchasing.purchaseorderheader": "purchaseorderheader",
    "purchasing.purchaseorderdetail": "purchaseorderdetail",
    "purchasing.vendor": "vendor"
}

production_tables = {
    "production.product": "product",
    "production.productcategory": "productcategory",
    "production.productsubcategory": "productsubcategory",
    "production.workorder": "workorder",
    "production.workorderrouting": "workorderrouting",
    "production.billofmaterials": "billofmaterials",
    "production.productinventory": "productinventory",
    "production.location": "location"
}

table_groups = [
    (sales_tables, sales_output_dir),
    (purchasing_tables, purchasing_output_dir),
    (production_tables, production_output_dir)
]

for tables, output_dir in table_groups:

    for table, filename in tables.items():

        print(f"Extracting {table}...")

        df = pd.read_sql(
            f"SELECT * FROM {table}",
            engine
        )

        file_dir = output_dir / filename
        file_dir.mkdir(parents=True, exist_ok=True)

        output_file = file_dir / f"{filename}.csv"

        df.to_csv(
            output_file,
            index=False
        )

        print(f"{table}: {len(df)} rows → {output_file}")