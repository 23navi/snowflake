-- CREATE NETWORK POLICY:

CREATE NETWORK POLICY my_corporate_np
  ALLOWED_IP_LIST = ('203.0.113.0/24', '198.51.100.10')
  BLOCKED_IP_LIST = ('192.168.0.0/16') -- Optional
  COMMENT = 'Allows connections only from corporate IPs, blocks a specific range.';


-- ALTER NETWORK POLICY:

-- Add more allowed IPs
ALTER NETWORK POLICY my_corporate_np
  SET ALLOWED_IP_LIST = ('203.0.113.0/24', '198.51.100.10', '203.0.113.50');

-- Modify blocked IPs
ALTER NETWORK POLICY my_corporate_np
  SET BLOCKED_IP_LIST = ('192.168.0.0/16', '10.0.0.0/8');

-- Update the comment
ALTER NETWORK POLICY my_corporate_np
  SET COMMENT = 'Updated policy for corporate network access.';



-- DROP NETWORK POLICY:
--To remove a network policy. You cannot drop a policy if it's currently active on an account, user, or security integration. You must unset it first.

DROP NETWORK POLICY my_corporate_np;



-- SHOW NETWORK POLICIES:
-- To list all network policies you have access to.

SHOW NETWORK POLICIES;
SHOW NETWORK POLICIES LIKE '%corporate%'; -- Filter by name


-- Applying/Unsetting Network Policies 

ALTER ACCOUNT SET NETWORK_POLICY = my_corporate_np;
ALTER ACCOUNT UNSET NETWORK_POLICY;


ALTER USER jane_doe SET NETWORK_POLICY = my_personal_np;
ALTER USER jane_doe UNSET NETWORK_POLICY;



-- Viewing Active Policy Information 

-- Check Account-level policy:
-- To see if an account-level network policy is currently active.

SHOW PARAMETERS LIKE 'network_policy' IN ACCOUNT;


-- Check User-level policy:
-- To see if a user-level network policy is currently active for a specific user.

SHOW PARAMETERS LIKE 'network_policy' IN USER <username>;
