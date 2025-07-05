-- Publicly accessible staging area    

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

-- List files in stage

LIST @MANAGE_DB.external_stages.aws_stage;

//Load data using copy command

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*OrderDetails.*';
    

USE DATABASE OUR_FIRST_DB;
USE SCHEMA PUBLIC;

    
-- Create table

CREATE OR REPLACE TABLE ORDERS_CACHING (
ORDER_ID	VARCHAR(30)
,AMOUNT	NUMBER(38,0)
,PROFIT	NUMBER(38,0)
,QUANTITY	NUMBER(38,0)
,CATEGORY	VARCHAR(30)
,SUBCATEGORY	VARCHAR(30)
,DATE DATE)   ; 



INSERT INTO ORDERS_CACHING 
SELECT
t1.ORDER_ID
,t1.AMOUNT	
,t1.PROFIT	
,t1.QUANTITY	
,t1.CATEGORY	
,t1.SUBCATEGORY	
,DATE(UNIFORM(1500000000,1700000000,(RANDOM())))
FROM ORDERS t1
CROSS JOIN (SELECT * FROM ORDERS) t2
CROSS JOIN (SELECT TOP 100 * FROM ORDERS) t3;


-- Query Performance before Cluster Key

SELECT * FROM ORDERS_CACHING  WHERE DATE = '2020-06-09';


-- Adding Cluster Key & Compare the result

ALTER TABLE ORDERS_CACHING CLUSTER BY ( DATE ) ;

SELECT * FROM ORDERS_CACHING  WHERE DATE = '2020-01-05';

-- This will not give the details regarding the clusters
Desc table ORDERS_CACHING


-- To get the details on clusters for the table, we will have to use this query
SELECT SYSTEM$CLUSTERING_INFORMATION('ORDERS_CACHING');



/*
{
  "cluster_by_keys" : "LINEAR( DATE )",
  "notes" : "Clustering key columns contain high cardinality key DATE which might result in expensive re-clustering. Please refer to https://docs.snowflake.net/manuals/user-guide/tables-clustering-keys.html for more information.",
  "total_partition_count" : 71,
  "total_constant_partition_count" : 0,
  "average_overlaps" : 2.2535,
  "average_depth" : 2.2535,
  "partition_depth_histogram" : {
    "00000" : 0,
    "00001" : 0,
    "00002" : 53,
    "00003" : 18,
    "00004" : 0,
    "00005" : 0,
    "00006" : 0,
    "00007" : 0,
    "00008" : 0,
    "00009" : 0,
    "00010" : 0,
    "00011" : 0,
    "00012" : 0,
    "00013" : 0,
    "00014" : 0,
    "00015" : 0,
    "00016" : 0
  },
  "clustering_errors" : [ ]
}

*/

ALTER TABLE ORDERS_CACHING DROP CLUSTERING KEY




-- Not ideal clustering & adding a different Cluster Key using function

SELECT * FROM ORDERS_CACHING  WHERE MONTH(DATE)=11;

ALTER TABLE ORDERS_CACHING CLUSTER BY ( MONTH(DATE) );