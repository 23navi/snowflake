# snowflake



Yes, you can define a FILE_FORMAT at both the stage level and the COPY INTO statement — but here's the key:

✅ The COPY INTO file format overrides the stage's file format if both are provided.