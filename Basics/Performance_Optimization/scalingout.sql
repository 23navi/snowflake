USE WAREHOUSE  XS_MULTICLUSTER_5;
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

-- This is a query that takes good amount of time to get processed
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T1
CROSS JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T2
CROSS JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T3
CROSS JOIN (SELECT TOP 57 * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE)  T4;

-- It took 2m 33s on XS single cluster vw


/*
For some reason my scaling out was not as quick as I imagined, in first try when I ran above query in a very quick succession, all of them went into running state and only one vw was up, no new clustr vw came up.

When I try to add more runs of the same query, some new VW came up but I think the speed of it can be improved.

*/