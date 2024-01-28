begin;

   -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
   set role_name = 'ACCOUNTADMIN';
   set user_name = 'ANKUR715';
   set user_password = 'Ank241592.';
   set warehouse_name = 'FIVETRAN_WAREHOUSE';
   set database_name = 'VIOLATIONS';

   -- change role to securityadmin for user / role steps
   use role securityadmin;

   -- create role for fivetran
   create role if not exists identifier($role_name);

   -- create a user for fivetran
   create user if not exists identifier($user_name)
   password = $user_password
   default_role = $role_name
   default_warehouse = $warehouse_name;

   -- grant the role to the fivetran user
   grant role identifier($role_name) to user identifier($user_name);

   -- change role to sysadmin for warehouse / database steps
   use role sysadmin;

   -- Only perform this step if you want to create a
   -- dedicated warehouse for fivetran (recommended)
   create warehouse if not exists identifier($warehouse_name)
   warehouse_size = xsmall
   warehouse_type = standard
   auto_suspend = 60
   auto_resume = true
   initially_suspended = true;

   -- change role to accountadmin to grant permissions
   use role ACCOUNTADMIN;

   -- grant fivetran role access to warehouse
   grant usage on warehouse identifier($warehouse_name)
   to role identifier($role_name);

   -- grant fivetran access to database
   grant usage on database identifier($database_name)
   to role identifier($role_name);

   use database identifier($database_name);

   -- add a statement like this one for each schema you want to have synced by fivetran
   grant usage on schema PUBLIC to role identifier($role_name);

   -- add statements granting select permissions and create table permissions if necessary (see step 5 below)

 commit;

