import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path

engine = create_engine(
    "postgresql+psycopg2://postgres:<your-password>@localhost:5432/adventure_works"
)

OUTPUT_DIR = Path("data/extracted")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

tables = {
    "sales.salesorderheader": "salesorderheader",
    "sales.salesorderdetail": "salesorderdetail",
    "sales.customer": "customer",
    "production.product": "product",
}

for table, filename in tables.items():

    print(f"Extracting {table}...")

    df = pd.read_sql(
        f"SELECT * FROM {table}",
        engine
    )

    output_file = OUTPUT_DIR / f"{filename}.csv"

    df.to_csv(
        output_file,
        index=False
    )

    print(f"{table}: {len(df)} rows → {output_file}")