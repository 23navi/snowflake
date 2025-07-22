 
 -- Download from Stage to local directory
GET @my_named_stage file://<path_to_file>/<filename> 
 
 
 --Download to D:\SnowflakeStageFiles
GET @my_named_stage file://D:\SnowflakeStageFiles


-- Get only specific file
GET @my_named_stage/data_0_0_0.csv.gz file://D:\SnowflakeStageFiles

-- Download from User Stage to D:\SnowflakeStageFiles
GET @~ file://D:\SnowflakeStageFiles

-- Upload file
PUT file://D:\SnowflakeStageFiles/data.csv @my_named_stage 
