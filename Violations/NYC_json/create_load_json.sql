USE Violations;
CREATE SCHEMA NYC_Json;
-- Creates a named file format that describes a set of staged data to access or load into Snowflake tables.
CREATE OR REPLACE FILE FORMAT json_format
    type = 'json'
    strip_outer_array = true;
-- Create an internal stage that is json_temp_int_stage with the file format is JSON type
-- temporary table in SQL Server is dropped when all connections are closed
CREATE STAGE json_temp_int_stage  -- temporary
  file_format = json_format;
CREATE OR REPLACE table json_table (json_data  variant );  -- temporary
-- Load JSON file to internal stage
PUT file://C:\Users\ankur\Desktop\socrata_metadata_parking_violations_2014.json @json_temp_int_stage;
// above errored: unsupported_requested_format:snowflake

// Running lines 4:13 in SnowSQL
-- rows.json was too large, so substituted with smaller document
SELECT * FROM Violations.NYC_JSON.JSON_TABLE LIMIT 1;
