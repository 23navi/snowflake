SHOW TABLES like '%CUSTOMERS%';

ALTER TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS
SET DATA_RETENTION_TIME_IN_DAYS = 1;

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.ret_example (
    id int,
    first_name string,
    last_name string,
    email string,
    gender string,
    Job string,
    Phone string)
DATA_RETENTION_TIME_IN_DAYS = 3;

SHOW TABLES like '%EX%';

DROP TABLE OUR_FIRST_DB.public.ret_example;
UNDROP TABLE OUR_FIRST_DB.public.ret_example;


ALTER TABLE OUR_FIRST_DB.public.ret_example
SET DATA_RETENTION_TIME_IN_DAYS = 0;