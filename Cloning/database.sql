-- Cloning Database
CREATE TRANSIENT DATABASE OUR_FIRST_DB_COPY
CLONE OUR_FIRST_DB;

DROP DATABASE OUR_FIRST_DB_COPY;
DROP SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED;
DROP SCHEMA OUR_FIRST_DB.COPIED_SCHEMA;
