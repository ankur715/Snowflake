# pip install snowflake-connector-python
import snowflake.connector as sf

user = "ANKUR715"
password = "Ank241592."
account = "kxunegy-gkb77032"
warehouse = "COMPUTE_WH"
database = "VIOLATIONS"
schema = "NYC"
table = "NYC_VIOLATIONS"

conn = sf.connect(user=user, password=password, account=account)

def run_query(connection, query):
    cursor = connection.cursor()
    cursor.execute(query)
    cursor.close()

# # test
# statement = "select * from " + database + "." + schema + "." + table
# run_query(conn, statement)

# copy S3 table to SF db
statement = "copy into VIOLATIONS.NYC.NYC_Violations \
             from @VIOLATIONS.NYC.snow_stage \
             file_format = (format_name=VIOLATIONS.PUBLIC.CSV_FORMAT) \
             on_error=continue;"
run_query(conn, statement)