-- download oltp db from microsoft site: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms
-- download install.sql script from here: https://github.com/lorint/AdventureWorks-for-Postgres

-- To ingest csv files into postgres:
-- cmd: psql -U postgres -c "CREATE DATABASE adventure_works;"
-- cmd: psql -U postgres -d adventure_works -f install.sql

-- dropping not required columns from the tables

-- customer table
select * from sales.customer;

alter table sales.customer
drop column rowguid cascade,
drop column modifieddate cascade;
-- cascade as views were dependent on sales.customer

-- saleseadorder table
select * from sales.salesorderheader;

alter table sales.salesorderheader
drop column comment cascade,
drop column rowguid cascade,
drop column modifieddate cascade;

-- salesorderdetail table
select * from sales.salesorderdetail;

alter table sales.salesorderdetail
drop column rowguid cascade,
drop column modifieddate cascade;

-- purchaseorderheader table
alter table purchasing.purchaseorderheader
drop column modifieddate cascade;

-- purchaseorderdetail table
alter table purchasing.purchaseorderdetail
drop column modifieddate cascade;

-- vendor table
alter table purchasing.vendor
drop column purchasingwebserviceurl cascade,
drop column modifieddate cascade;

-- product table
alter table production.product
drop column rowguid cascade,
drop column modifieddate cascade;

-- productcategory table
alter table production.productcategory
drop column rowguid cascade,
drop column modifieddate cascade;

-- productsubcategory table
alter table production.productsubcategory
drop column rowguid cascade,
drop column modifieddate cascade;

-- productinventory table
alter table production.productinventory
drop column rowguid cascade,
drop column modifieddate cascade;

-- billofmaterials table
alter table production.billofmaterials
drop column modifieddate cascade;

-- workorder table
alter table production.workorder
drop column modifieddate cascade;

-- workorderrouting table
alter table production.workorderrouting
drop column modifieddate cascade;

-- location table
alter table production.location
drop column costrate cascade,
drop column modifieddate cascade;