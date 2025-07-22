-- Set context
USE MANAGE_DB;

-- Show files in stage
LIST @stage_azure;

-- Query table
SELECT * FROM COPY_DB.PUBLIC.ORDERS;

-- Unload data
COPY INTO @stage_azure/myfile
FROM COPY_DB.PUBLIC.ORDERS;


CREATE STAGE my_named_stage;


-- Unload data to named stage
COPY INTO @my_named_stage
FROM COPY_DB.PUBLIC.ORDERS;

-- Unload data to user stage
COPY INTO @~
FROM COPY_DB.PUBLIC.ORDERS;

LIST @my_named_stage;

-- Remove files
REMOVE @my_named_stage;

REMOVE @~;
