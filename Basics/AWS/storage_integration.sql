-- Create storage integration object

/*
We created the iam role with policy of 

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::navi23-snowflake-open-bucket/\\*"   -- \\ is just a escape
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::navi23-snowflake-open-bucket"
        }
    ]
}


*/



create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::369464770997:role/snowflakes_readonly_for_navi23-snowflake-open-bucket'
  STORAGE_ALLOWED_LOCATIONS = ('s3://navi23-snowflake-open-bucket/csv/','s3://navi23-snowflake-open-bucket/json/')
   COMMENT = 'This an optional comment' ;
   
   
// See storage integration properties to fetch external_id so we can update it in S3
DESC integration s3_int;


/*
This will give me STORAGE_AWS_EXTERNAL_ID and STORAGE_AWS_IAM_USER_ARN which I need to go to aws and update in role trust relationship
*/





-- Now we will use this integration to do data load



-- Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.movie_titles (
  show_id STRING,
  type STRING,
  title STRING,
  director STRING,
  cast STRING,
  country STRING,
  date_added STRING,
  release_year STRING,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING )
  
  

-- Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')  -- Chnage the occurance on string 'null' or 'NULL' in the csv to be NULL in db, not null as a string 
    empty_field_as_null = TRUE; -- Treat empty entry as db  NULL (abc,,xyz -> abc,NULL,xyz)
    
    
-- Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
    URL = 's3://navi23-snowflake-open-bucket/csv/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat


-- Run the list cmmand on our stage to verify that our storage integration worked to authenticate to our bucket.
ls @MANAGE_DB.external_stages.csv_folder


-- Use Copy command      (This will fail)  
COPY INTO OUR_FIRST_DB.PUBLIC.movie_titles
    FROM @MANAGE_DB.external_stages.csv_folder
    
-- The above copy will fail
    
    
    
-- Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'    


-- Use Copy command      (This will pass)  
COPY INTO OUR_FIRST_DB.PUBLIC.movie_titles
    FROM @MANAGE_DB.external_stages.csv_folder
    
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.movie_titles
    
    