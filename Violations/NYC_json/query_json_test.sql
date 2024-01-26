SET json='{"name":"John","surname":"Doe","age":45,"skills":["SQL","C#","MVC"]}';
SHOW VARIABLES;
UNSET json;

USE SCHEMA Violations.NYC_JSON;

-- Create a table with a JSON column
create table jsonRecord(jsonRecord variant);

-- Add JSON data to Snowflake
INSERT INTO JSONRECORD (jsonrecord) select PARSE_JSON('{"customer": "Walker"}');
INSERT INTO JSONRECORD (jsonrecord) select PARSE_JSON('{"customer": "Stephen"}');
INSERT INTO JSONRECORD (jsonrecord) select PARSE_JSON('{"customer": "Aphrodite", "age": 32}');
select * from jsonRecord;

INSERT INTO JSONRECORD (jsonrecord) select PARSE_JSON(' {
            "customer": "Aphrodite",
            "age": 32,
            "orders": [{
                                    "product": "socks",
                                    "quantity": 4
                        },
                        {
                                    "product": "shoes",
                                    "quantity": 3
                        }
            ]
 }');
INSERT INTO JSONRECORD (jsonrecord) select PARSE_JSON(' {
            "customer": "Nina",
            "age": 52,
            "orders": [{
                                    "product": "socks",
                                    "quantity": 3
                        },
                        {
                                    "product": "shirt",
                                    "quantity": 2
                        }
            ]
 }');
select * from jsonRecord;

INSERT INTO JSONRECORD (jsonrecord) select PARSE_JSON(' {
            "customer": "Maria",
            "age": 22,
     "address" : { "city": "Paphos", "country": "Cyprus"},                                                   
            "orders": [{
                                    "product": "socks",
                                    "quantity": 3
                        },
                        {
                                    "product": "shirt",
                                    "quantity": 2
                        }
            ]
 }');
select * from jsonRecord;

-- How to select JSON data in Snowflake
select jsonrecord:customer from JSONRECORD;

select get_path(jsonrecord, 'address') from JSONRECORD;

select get_path(jsonrecord, 'orders') from JSONRECORD;

select jsonrecord['address']['city'] from JSONRECORD 
    where jsonrecord:customer = 'Maria';
select jsonrecord['orders'][0]['quantity'] from JSONRECORD;

select jsonrecord['orders'][0] from JSONRECORD 
    where jsonrecord:customer = 'Maria';

select jsonrecord:customer, jsonrecord:orders  from JSONRECORD;
select jsonrecord:customer, jsonrecord:age, jsonrecord:orders  from JSONRECORD ,
   lateral flatten(input => jsonrecord:orders) prod;

select PARSE_JSON(jsonrecord['orders']) from JSONRECORD;

/*
Create Target table and Copy Into it
*/
CREATE TABLE JSONRECORD_structured (
    customer string,
    age int,
    city string,
    country string,
    order_product string,
    order_quantity string
);
select * from JSONRECORD_structured;

INSERT INTO JSONRECORD_STRUCTURED 
SELECT jsonrecord:customer, jsonrecord:age, 
       jsonrecord['address']['city'], jsonrecord['address']['country'],
       CONCAT(jsonrecord['orders'][0]['product'], ', ', jsonrecord['orders'][1]['product']),
       CONCAT(TO_VARCHAR(jsonrecord['orders'][0]['quantity']), ', ', TO_VARCHAR(jsonrecord['orders'][1]['quantity']))
FROM JSONRECORD;
select * from JSONRECORD_structured;
