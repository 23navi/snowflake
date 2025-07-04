---- VALIDATION_MODE ----

-- Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;


CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

-- Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;

-- This bucket will have 2 files with size 
/*
s3://snowflakebucket-copyoption/size/Orders.csv : 54600
s3://snowflakebucket-copyoption/size/Orders2.csv: 54598
*/

  
    
-- Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;

-- The above command returns: Query produced no results (ie there were no error in loading the files) but no data will be loaded to the table.
    
SELECT * FROM ORDERS;     -- Verify that no data was loaded in the table when using VALIDATION_MODE
    
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS ;

-- The above query will give the first 5 rows 



--- Use files with errors ---

create or replace stage copy_db.public.aws_stage_copy
    url ='s3://snowflakebucket-copyoption/returnfailed/';
    
list @copy_db.public.aws_stage_copy;


/*
We get 4 files

s3://snowflakebucket-copyoption/returnfailed/OrderDetails_error.csv	54622
s3://snowflakebucket-copyoption/returnfailed/OrderDetails_error2 - Copy.csv	10514
s3://snowflakebucket-copyoption/returnfailed/Orders.csv	54597
s3://snowflakebucket-copyoption/returnfailed/Orders2.csv	54598
*/

-- show all errors --
copy into copy_db.public.orders
    from @copy_db.public.aws_stage_copy
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    validation_mode=return_errors;


/*
Error	                	                	        File with error
Numeric value '7-' is not recognized	                returnfailed/OrderDetails_error2 - Copy.csv	2
Numeric value '3a' is not recognized	                returnfailed/OrderDetails_error2 - Copy.csv	4
Numeric value 'one thousand' is not recognized	        returnfailed/OrderDetails_error.csv	2
Numeric value 'two hundred twenty' is not recognized	returnfailed/OrderDetails_error.csv	3

The above command will give me the errors and the file+line+other details about that error
*/

-- validate first n rows --
copy into copy_db.public.orders
    from @copy_db.public.aws_stage_copy
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern='.*error.*'
    validation_mode=return_1_rows;
    
    
/*
The above command filed to return the first line, that means that there was an error on the first line of the first file

Numeric value 'one thousand' is not recognized	: returnfailed/OrderDetails_error.csv :	2
*/





--- -- Practice



-- Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;


CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.employees (
  customer_id int,
  first_name varchar(50),
  last_name varchar(50),
  email varchar(50),
  age int,
  department varchar(50)
  );


create or replace stage copy_db.public.aws_stage_excercise
    url ='s3://snowflake-assignments-mc/copyoptions/example1';


LS @copy_db.public.aws_stage_excercise;
-- We get 1 file


create or replace schema manage_db.file_formates;

create or replace file format manage_db.file_formates.aws_stage_excercise_ffo
    TYPE=csv
    FIELD_DELIMITER=','
    SKIP_HEADER=1;



copy into COPY_DB.PUBLIC.employees
    from @copy_db.public.aws_stage_excercise
    file_format = (format_name=manage_db.file_formates.aws_stage_excercise_ffo)
    validation_mode=return_errors;
-- We got one error



copy into COPY_DB.PUBLIC.employees
    from @copy_db.public.aws_stage_excercise
    file_format = (format_name=manage_db.file_formates.aws_stage_excercise_ffo)
    -- validation_mode=return_errors;
    ON_Error=Continue

select * from COPY_DB.PUBLIC.employees