# snowflake



Yes, you can define a FILE_FORMAT at both the stage level and the COPY INTO statement — but here's the key:

✅ The COPY INTO file format overrides the stage's file format if both are provided.




### Caching

Why is warehouse cost not charged based on query run time? 
In snowflake the charges is for time the warehouse is on, why do we have such infra?

Bec of the caching layer, the query caches are stored at virtual warehouse and as soon as the warehouse is down, the cache is also cleard. So for many usecases it is better to keep the warehouse up so that we can benifit from the caching.


--- 


#### "Snowflake uses a hybrid of shared-disk and shared-nothing architecture"



🔍 The Meaning of:
"Snowflake uses a hybrid of shared-disk and shared-nothing architecture."

This means Snowflake combines the benefits of two classic database architectures:

1. ✅ Shared-Disk
        Storage is centralized and accessible by all compute nodes.

        In Snowflake:

        🔹 All data is stored in centralized cloud storage (S3, Azure Blob, GCS). 

        🔹 All compute clusters (called Virtual Warehouses) can access the same data.

        Think of it as one big pool of data, and any compute node can read from it.

2. ✅ Shared-Nothing
        Compute nodes are fully independent — they don’t share memory or disk.

        In Snowflake:

        🔹 Each Virtual Warehouse (cluster of compute) works independently.

        🔹 There is no resource contention between different warehouses.

        Each query runs in its own isolated compute environment, and scaling is horizontal (you can spin up more warehouses as needed).




### Questions

1) Which parameter can be used to set a minimum retention period on the account level for which data is retained when performing time travel? -> MIN_DATA_RETENTION_TIME_IN_DAYS

