use supplychain;
SET SQL_SAFE_UPDATES = 0;

select Count(*) from shippings;


create table orders(
Shipment_ID	varchar(50),
Order_Date	date,
Promised_Delivery_Date	date,
Actual_Delivery_Date	date,
Delay_Days	int,
Delay_Status	varchar(50),
On_Time_Flag	int,
Origin_City	varchar(50),
Origin_State	varchar(50),
Origin_Region	varchar(50),
Destination_City	varchar(50),
Destination_State	varchar(50),
Destination_Region	varchar(50),
Route_ID	varchar(50),
Distance_Miles	float,
Warehouse_ID	varchar(50),
Warehouse_City	varchar(50),
Warehouse_State	varchar(50),
Carrier	varchar(50),
Ship_Mode	varchar(50),
Product_Category	varchar(50),
Product_Weight_kg	float,
Order_Value	float,
Shipping_Cost	float,
Customer_Segment	varchar(50),
Customer_ID	varchar(50),
Weather_Condition	varchar(50),
Traffic_Condition	varchar(50),
avg_delay	int,
year	int,
month	int,
day	int,
quater	int,
month_name	varchar(50),
day_name	varchar(50)
);

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA local INFILE 'C:\Users\balac\OneDrive\Desktop\supply_chain_management\python\python_output\Cleaned_data_supply_chain.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;  


select * from orders
limit 5;


select count(*) from orders;

--- kpi 1  On-Time Delivery Rate---
with ontime_deliveries as(select count(*) as ontime_delivery from orders where On_Time_Flag=1)
select round((ontime_delivery/(select count(*) from orders))*100,2) from ontime_deliveries;
 

--- AVG(Delay_Days) WHERE Delay_Days >0 ---

select Avg(Delay_Days) as avg_delay_days from orders
where Delay_Days>0;

--- aVG SHIPPING COST---

select round(sum(Order_Value),2)
 as shippingcost from orders;
 
 
 --- Normlization---
 
 create table origins
 select distinct  Origin_City,Origin_State,Origin_Region from orders;
 
 alter table origins
 add column origin_id int auto_increment primary key;
 
 create table destinations
 select distinct Destination_City,Destination_State,Destination_Region from orders;
 
 alter table destinations
 add column destination_id int auto_increment primary key;
 
 
 select * from destinations;
 
 create table routes 
 select  distinct Route_ID  from orders;
 
 alter table routes
 add primary key (Route_ID);
 
 select * from routes;
 
 
 create table routes 
 select distinct Route_ID,Origin_City,Origin_State,Origin_Region,Destination_City,Destination_State,Destination_Region from orders;
 
 drop table routes;
 
 create table warehouses
 select distinct Warehouse_ID,Warehouse_City,Warehouse_State from orders;
 
 
 select * from warehouses;
 
 alter table warehouses
 add primary key (Warehouse_ID);
 
 create table carriers
 select distinct Carrier,Ship_Mode from orders;
 
 alter table carriers 
 add column caarier_id int auto_increment primary key;
 select * from carriers;
 
 create table products_cat
 select distinct Product_Category from orders;
 
 alter table products_cat
 add column category_id int auto_increment primary key;
 
 drop table customers;
 
 create table customers
 select distinct Customer_ID from orders;
 
create table customer_segment
select distinct Customer_Segment from orders;



 
 alter table customer_segment
 add column seg_id int auto_increment primary key;
 select * from customer_segment;
 

create table fact_table 
select Shipment_ID,Order_Date,
Promised_Delivery_Date,Actual_Delivery_Date,Delay_Days,Delay_Status,On_Time_Flag,Route_ID,Warehouse_ID,Customer_ID,Weather_Condition ,Traffic_Condition 
from orders;

drop table fact_table;

select * from fact_table;

alter table orders
add column  seg_id int,
add column  caarier_id int,
add column  destination_id int,
add column  origin_id int,
add column category_id int;

update orders f
join customer_segment c
on f.Customer_Segment=c.Customer_Segment
set f.seg_id=c.seg_id;

update orders f
join carriers c 
on f.Carrier=c.Carrier and f.Ship_Mode=c.Ship_Mode
set f.caarier_id=c.caarier_id;

update orders f
join destinations d 
on f.Destination_City=d.Destination_City and f.Destination_State=d.Destination_State
and f.Destination_Region=d.Destination_Region
set f.destination_id=d.destination_id;

update orders f
join origins d 
on f.Origin_City=d.Origin_City and f.Origin_State=d.Origin_State
and f.Origin_Region=d.Origin_Region
set f.origin_id=d.origin_id;

update orders  f
join products_cat d
on d.Product_Category=f.Product_Category
set f.category_id=d.category_id;


-- Then run update
SET SQL_SAFE_UPDATES = 0;
SET SESSION wait_timeout = 600;
SET SESSION interactive_timeout = 600;

UPDATE orders f 
JOIN products_cat d ON f.Product_Category = d.Product_Category 
SET f.category_id = d.category_id
where f.category_id is null
AND f.Shipment_ID IN (
    SELECT Shipment_ID FROM (
        SELECT Shipment_ID FROM orders 
        WHERE category_id IS NULL 
        LIMIT 1000
    ) tmp
);

SET SQL_SAFE_UPDATES = 1;
 


create index index_1 on orders(Destination_City,Destination_State,Destination_Region);
create index index_dc on destinations(Destination_City,Destination_State,Destination_Region);
create index index_oo on orders(Origin_City,Origin_State,Origin_Region);
create index index_o on origins(Origin_City,Origin_State,Origin_Region);
create index index_op on orders(Product_Category);
create index index_p on products_cat(Product_Category);

set sql_safe_updates=0;


select * from orders;

alter table orders
add foreign key(Route_ID)
references routes(Route_ID);

 
alter table orders
add foreign key(caarier_id)
references carriers(caarier_id);

alter table orders
add foreign key(seg_id)
references customer_segment(seg_id);

alter table orders
add foreign key(destination_id)
references destinations(destination_id);

alter table orders
add foreign key(origin_id)
references origins(origin_id);

alter table orders
add foreign key(category_id)
references products_cat(category_id);

select o.Carrier,o.Ship_Mode,o.caarier_id,c.caarier_id,c.Carrier,c.Ship_Mode from orders o
join carriers c
on o.caarier_id=c.caarier_id
order by c.caarier_id desc;

select o.seg_id,c.seg_id,c.Customer_Segment from fact_table o
left join customer_segment c
on o.seg_id=c.seg_id;

select o.Destination_City,o.Destination_State,o.Destination_Region,o.destination_id,d.destination_id,d.Destination_City,d.Destination_State,d.Destination_Region
 from orders o
 left join destinations d 
 on o.destination_id=d.destination_id;


create table fact_table
select Shipment_ID,Order_Date,Promised_Delivery_Date,Actual_Delivery_Date,Delay_Days,Delay_Status,
On_Time_Flag,Route_ID,Warehouse_ID,seg_id,caarier_id,destination_id,Customer_ID,origin_id,category_id,Order_Value,Shipping_Cost,Weather_Condition,
Traffic_Condition,`year`,`month`,`day`,quater,month_name,day_name from orders;

use supplychain;
drop table fact_table;

-- Check all tables created
SHOW TABLES;

-- Check all foreign keys are in place
SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'supplychain'
AND REFERENCED_TABLE_NAME IS NOT NULL;

SELECT COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'supplychain'
AND TABLE_NAME = 'fact_table'
AND REFERENCED_TABLE_NAME = 'routes';


ALTER TABLE orders DROP FOREIGN KEY orders_ibfk_2;
ALTER TABLE orders DROP FOREIGN KEY orders_ibfk_3;
ALTER TABLE orders DROP FOREIGN KEY orders_ibfk_4;
ALTER TABLE orders DROP FOREIGN KEY orders_ibfk_5;

SELECT COUNT(*) FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'supplychain'
AND TABLE_NAME = 'fact_table'
AND REFERENCED_TABLE_NAME IS NOT NULL;

---- Kpi Analysis---

--- 1 on time Percentage---

select round((count(On_Time_Flag)/(select count(On_Time_Flag)  from orders))*100,2) as ontime_delivery_per from orders
where On_Time_Flag=1; 

--- 2 delay impact on avg shippingcost---
select round((count(On_Time_Flag)*(select avg(Shipping_Cost)  from orders))*100,2) as delay_impact_shippingcost from orders
where On_Time_Flag=0; 

--- total avg shipping cost per shipment---

select round(sum(Shipping_Cost)/count(*),2) from orders;

--- routes----
select r.Route_ID,
count(case when o.On_Time_Flag=1 then 1 end) as ontime,
count(o.On_Time_Flag) as total,
round((count(case when o.On_Time_Flag=1 then 1 end)/count(o.On_Time_Flag))*100,0) as percent
from orders o
left join routes r
on r.Route_ID=o.Route_ID
group by r.Route_ID; 

---- carrier ----
select c.Carrier,
count(case when o.On_Time_Flag=1 then 1 end) as ontime,
count(o.On_Time_Flag) as total_orders,
round((count(case when o.On_Time_Flag=1 then 1 end)/count(o.On_Time_Flag))*100,2) as total_percent
from orders o
left join carriers c
on c.caarier_id=o.caarier_id
group by c.Carrier;


select c.Ship_Mode,
count(case when o.On_Time_Flag=1 then 1 end) as ontime,
count(o.On_Time_Flag) as total_orders,
round((count(case when o.On_Time_Flag=1 then 1 end)/count(o.On_Time_Flag))*100,2) as total_percent
from orders o
left join carriers c
on c.caarier_id=o.caarier_id
group by c.Ship_Mode;


select w.Warehouse_ID,
count(case when o.On_Time_Flag=1 then 1 end) as ontime,
count(o.On_Time_Flag) as total_orders,
round((count(case when o.On_Time_Flag=1 then 1 end)/count(o.On_Time_Flag))*100,2) as total_percent,

round((count(case when o.On_Time_Flag=0 then 1 end)/count(o.On_Time_Flag))*100,2) as total_delaypercent
from orders o
left join warehouses w 
on w.Warehouse_ID=o.Warehouse_ID
group by w.Warehouse_ID;


--- weather---
select o.Weather_Condition,
count(case when o.On_Time_Flag=1 then 1 end) as ontime,
count(o.On_Time_Flag) as total_orders,
avg(case when o.Delay_Days>0 then Delay_Days end) as avg_delay,
round((count(case when o.On_Time_Flag=1 then 1 end)/count(o.On_Time_Flag))*100,2) as total_percent,

round((count(case when o.On_Time_Flag=0 then 1 end)/count(o.On_Time_Flag))*100,2) as total_delaypercent
from orders o
left join warehouses w 
on w.Warehouse_ID=o.Warehouse_ID
group by o.Weather_Condition;


select Weather_Condition ,avg(Delay_Days) from orders
where Delay_Days>0
group by Weather_Condition;

--- Traffic---

select Traffic_Condition,
count(case when On_Time_Flag=1 then 1 end) as ontime,
count(On_Time_Flag) as total_orders,
avg(case when Delay_Days>0 then Delay_Days end) as avg_delay,
round((count(case when On_Time_Flag=1 then 1 end)/count(On_Time_Flag))*100,2) as total_percent,

round((count(case when On_Time_Flag=0 then 1 end)/count(On_Time_Flag))*100,2) as total_delaypercent
from orders

group by Traffic_Condition;

--- monthly trend---
select `year`,month_name,
count(case when On_Time_Flag=1 then 1 end) as ontime,
count(On_Time_Flag) as total_orders,
avg(case when Delay_Days>0 then Delay_Days end) as avg_delay,
round((count(case when On_Time_Flag=1 then 1 end)/count(On_Time_Flag))*100,2) as total_percent,

round((count(case when On_Time_Flag=0 then 1 end)/count(On_Time_Flag))*100,2) as total_delaypercent
from orders

group by `year`, month_name;

--- seasonal analysis---
select `year`, quater,
count(case when On_Time_Flag=1 then 1 end) as ontime,
count(On_Time_Flag) as total_orders,
avg(case when Delay_Days>0 then Delay_Days end) as avg_delay,
round((count(case when On_Time_Flag=1 then 1 end)/count(On_Time_Flag))*100,2) as total_percent,

round((count(case when On_Time_Flag=0 then 1 end)/count(On_Time_Flag))*100,2) as total_delaypercent
from orders

group by `year`,quater ;


select round((count(*)*sum(Distance_Miles*On_Time_Flag)-sum(Distance_Miles)*sum(On_Time_Flag)) /
sqrt((count(*)*sum(Distance_Miles*Distance_Miles)-sum(Distance_Miles)*sum(Distance_Miles))*(count(*)*sum(On_Time_Flag*On_Time_Flag)-sum(On_Time_Flag)*sum(On_Time_Flag))),4)
as num from orders;

-- Example: Weather_Condition (text) vs Delay_Days
SELECT
    ROUND(
        (COUNT(*) * SUM(
            CASE Weather_Condition
                WHEN 'Sunny' THEN 1
                WHEN 'Cloudy' THEN 2
                WHEN 'Rainy' THEN 3
                WHEN 'Stormy' THEN 4
                when "Unknown" then 5
                ELSE 0
            END * Delay_Days)
        - SUM(CASE Weather_Condition
                WHEN 'Sunny' THEN 1
                WHEN 'Cloudy' THEN 2
                WHEN 'Rainy' THEN 3
                WHEN 'Stormy' THEN 4
                when "Unknown" then 5
                ELSE 0
            END) * SUM(Delay_Days))
        /
        SQRT(
            (COUNT(*) * SUM(POW(CASE Weather_Condition
                WHEN 'Sunny' THEN 1
                WHEN 'Cloudy' THEN 2
                WHEN 'Rainy' THEN 3
                WHEN 'Stormy' THEN 4
                when "Unknown" then 5
                ELSE 0 END, 2))
            - POW(SUM(CASE Weather_Condition
                WHEN 'Sunny' THEN 1
                WHEN 'Cloudy' THEN 2
                WHEN 'Rainy' THEN 3
                WHEN 'Stormy' THEN 4
                when "Unknown" then 5
                ELSE 0 END), 2))
            *
            (COUNT(*) * SUM(Delay_Days * Delay_Days) - SUM(Delay_Days) * SUM(Delay_Days))
        )
    , 4) AS Weather_vs_Delay
FROM orders;


-- Check 1: Null values in columns
SELECT 
    SUM(CASE WHEN Weather_Condition IS NULL THEN 1 ELSE 0 END) AS Weather_Nulls,
    SUM(CASE WHEN Delay_Days IS NULL THEN 1 ELSE 0 END) AS Delay_Nulls
FROM orders;

-- Check 2: See distinct values
SELECT DISTINCT Weather_Condition FROM orders;


select sum(Shipping_Cost),max(Order_Date),min(Order_Date) from orders;

select Delay_Status ,avg(Delay_Days) from orders
group by Delay_Status;


