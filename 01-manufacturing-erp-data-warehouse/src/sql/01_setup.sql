-- create database and schema (BRONZE)
CREATE DATABASE ADVENTUREWORKS_DW;
use database adventureworks_dw;

CREATE OR REPLACE SCHEMA ADVENTUREWORKS_DW.BRONZE;
use schema adventureworks_dw.bronze;

-- define file_format for files to be ingested
CREATE OR REPLACE FILE FORMAT ADVENTUREWORKS_DW.BRONZE.CSV_FORMAT
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL', '');

-- create storage integration to connect azure blob storage to snowflake
CREATE OR REPLACE STORAGE INTEGRATION AZURE_BLOB_INT
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'AZURE'
    ENABLED = TRUE
    AZURE_TENANT_ID = 'XXXXXXXXXXXXXXXXXXXXXX'
    STORAGE_ALLOWED_LOCATIONS = (
        'azure://adventureworksstacc.blob.core.windows.net/adventureworks/landing/'
    );

DESC STORAGE INTEGRATION AZURE_BLOB_INT;

-- creating notifications for queue
CREATE OR REPLACE NOTIFICATION INTEGRATION AZURE_SNOWPIPE_INT
    TYPE = QUEUE
    NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
    ENABLED = TRUE
    AZURE_STORAGE_QUEUE_PRIMARY_URI ='https://adventureworksstacc.queue.core.windows.net/adventureworks-queue'
    AZURE_TENANT_ID = 'XXXXXXXXXXXXXXXXXXXXXX';

DESC NOTIFICATION INTEGRATION AZURE_SNOWPIPE_INT;

-- creating stage for azure blob ingested files
CREATE OR REPLACE STAGE ADVENTUREWORKS_BRONZE_STAGE
    URL = 'azure://adventureworksstacc.blob.core.windows.net/adventureworks/landing/'
    STORAGE_INTEGRATION = AZURE_BLOB_INT
    FILE_FORMAT = ADVENTUREWORKS_DW.BRONZE.CSV_FORMAT;

LIST @ADVENTUREWORKS_BRONZE_STAGE;