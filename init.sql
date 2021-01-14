CREATE USER gvm;
CREATE DATABASE gvmd;
GRANT ALL PRIVILEGES ON DATABASE gvmd TO gvm;

use gvmd;
create role dba with superuser noinherit;
grant dba to gvm;
create extension "uuid-ossp";
