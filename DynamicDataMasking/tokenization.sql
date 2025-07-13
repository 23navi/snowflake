/*
When we perform masking, we loose all analytical ability, say we want to do group by or order by or get distribution for that column without exposing the PII/Sensitive data. We can use soemthing called tokenization.


Tokenization is the process of replacing sensitive data with non-sensitive equivalents (called tokens) that have no exploitable meaning or value if breached, but can still be used in specific systems or workflows.


Why Use Tokenization?

* Security: If attackers get tokens, they can’t reverse them without access to the vault.

* Compliance: Helps with PCI DSS, HIPAA, GDPR, etc.

* Minimized risk: Reduces the exposure of sensitive data in databases, logs, or during analytics.
*/



/*
Eg: You want to tokenize sensitive data like a Social Security Number (SSN) for most users, but allow certain roles to see the real value.
*/

-- Step 1: Create a Sample Table

CREATE OR REPLACE TABLE employee_data (
    employee_id INT,
    full_name STRING,
    ssn STRING  -- Sensitive column
);


-- Step X: Insert Sample Data 

INSERT INTO employee_data (employee_id, full_name, ssn)
VALUES 
(1, 'Alice Smith', '123-45-6789'),
(2, 'Bob Johnson', '987-65-4321');



-- Step 2: Create a Role for Limited Access Users

CREATE OR REPLACE ROLE limited_access_role;
GRANT USAGE ON SCHEMA public TO ROLE limited_access_role;
GRANT SELECT ON TABLE employee_data TO ROLE limited_access_role;


-- Step 3: Create a Masking Policy Using Tokenization

CREATE OR REPLACE MASKING POLICY ssn_tokenization_policy AS (val STRING) 
RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE') THEN val
        ELSE SHA2(val, 256)  -- Tokenized output
    END;



-- Step 4: Apply the Masking Policy to the ssn Column

ALTER TABLE employee_data 
MODIFY COLUMN ssn 
SET MASKING POLICY ssn_tokenization_policy;


-- Step 5: Run query with tokenize data