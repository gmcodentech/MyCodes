-- Database: ProductsDB

-- DROP DATABASE IF EXISTS "ProductsDB";

CREATE DATABASE "ProductsDB"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
	
CREATE TABLE IF NOT EXISTS public."Products"
(
    id integer NOT NULL DEFAULT nextval('"Products_id_seq"'::regclass),
    name character varying COLLATE pg_catalog."default",
    price money,
    units integer
)



Insert Into public."Products"(name,price,units)values('Sugar',12.5,100)

Insert Into public."Products"(name,price,units)values('Coffee',182.5,50)

Insert Into public."Products"(name,price,units)values('Tea',82.5,10)


Select * From public."Products"