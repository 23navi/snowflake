# snowflake



Yes, you can define a FILE_FORMAT at both the stage level and the COPY INTO statement — but here's the key:

✅ The COPY INTO file format overrides the stage's file format if both are provided.




### Caching

Why is warehouse cost not charged based on query run time? 
In snowflake the charges is for time the warehouse is on, why do we have such infra?

Bec of the caching layer, the query caches are stored at virtual warehouse and as soon as the warehouse is down, the cache is also cleard. So for many usecases it is better to keep the warehouse up so that we can benifit from the caching.

