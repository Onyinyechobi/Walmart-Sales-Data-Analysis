CREATE TABLE Walmart_Sales (
    Invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    Branch VARCHAR(5) NOT NULL,
    City VARCHAR(30) NOT NULL,
    Customert_Type VARCHAR(30) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Product_line VARCHAR(100) NOT NULL,
    Unit_price DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    VAT FLOAT NOT NULL, -- Corrected FLOAT declaration
    Total DECIMAL(12,4) NOT NULL,
    Sale_DateTime TIMESTAMP NOT NULL, -- Using TIMESTAMP for date and time
    Payment_Method VARCHAR(15) NOT NULL,
    COGS DECIMAL(10,2) NOT NULL,
    Gross_Margin_Pct FLOAT NOT NULL, -- Corrected FLOAT declaration
    Gross_Income DECIMAL(12,4) NOT NULL,
    Rating FLOAT NOT NULL
);
 select * from Walmart_Sales;
 
 select time from walmart_sales;
 ----------------------------------------- Feature Engineering.............
 ----Time_of_day
SELECT
  time,
  CASE
    WHEN time BETWEEN TIME '00:00:00' AND TIME '12:00:00' THEN 'Morning'
    WHEN time BETWEEN TIME '12:01:00' AND TIME '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END AS Time_of_the_Day
FROM
  walmart_sales;
  
  Alter table Walmart_sales
  add column time_of_the_day
  varchar(20);
  
  select * from walmart_sales;
  
  update walmart_Sales
  set time_of_the_day
  =(CASE
    WHEN time BETWEEN TIME '00:00:00' AND TIME '12:00:00' THEN 'Morning'
    WHEN time BETWEEN TIME '12:01:00' AND TIME '16:00:00' THEN 'Afternoon'
    ELSE 'Evening' End);
 
 ---------
---Day_Name

SELECT
  date,
  to_char(date, 'Day') AS day_name
FROM
  walmart_sales;
 
 alter table walmart_sales
 add column day_name
 varchar(10);
 
 select * from walmart_sales;
  
 UPDATE walmart_sales
SET day_name = to_char(date, 'Day');

------ month_name---

SELECT
  date,
  to_char(date, 'Month') AS month_name
FROM
  walmart_sales;
  
  
  alter table walmart_sales
  add column month_name
  varchar(10);
  
  select * from walmart_sales;
  
  update walmart_sales
  set month_name =to_char(date, 'Month')
  
  -------------------------------------------------------------------------------
  ----Business question to answer---
  -- Generic question--
  --1. How many Unique Cities does the data have?
  select distinct city
  from walmart_sales;
  
 ---2. In which city is each branch?---
select distinct  City, branch
  from walmart_sales;
  
  -------------------------------------------------------------------------------------------------------
  --Product--
  --1. How many unique product
-- lines does the data have?

Select distinct product_line from walmart_sales;

select count(distinct product_line)from walmart_sales;

---2. what is the most common payment method?

select payment_method from walmart_sales;
 
select payment_method, count(payment_method) as Cnt
from walmart_sales
group by payment_method
order by cnt desc;

----3. What is the most selling product line?

select product_line, count(product_line) as P_Cnt
from walmart_sales
group by product_line
order by P_Cnt desc;

------4. what is the total revenue by month?

select month_name as month,sum(total) as total_revenue
from walmart_sales
group by month_name
order by total_revenue desc;

---5. What month had the largest COGS?--
select
month_name as Month,
sum(cogs) as cogs
from walmart_sales
group by month_name
order by cogs desc;


--- 6. What product line had the largest revenue?

select product_line,
sum(total) as Total_revenue
from walmart_sales
group by product_line
order by total_revenue desc;

------7.what is the city with the largest revenue?

select city,branch,
sum(total) as Total_revenue
from walmart_sales
group by city,branch
order by total_revenue desc;


--8.- what product line had the largest VAT?

SELECT
  product_line,
  AVG("Tax_5%") AS avg_tax
FROM
  walmart_sales
GROUP BY
  product_line
ORDER BY
  avg_tax DESC;
  

----9. which branch sold more products
---than average sold?

select branch,
sum(quantity) as qty
from walmart_sales
group by branch
having sum(quantity)>(select
AVG(quantity) from walmart_sales);

	----10. what is the most common product line
	----by gender
	
	select gender,
	product_line,
	count(gender)as total_cnt
	from walmart_sales
	
	group by gender, product_line
	order by total_cnt desc;
	
	-----11. What is the average rating
	---- of each product_line?
	
	select AVG(rating) as Avg_rating,
	product_line
	from walmart_sales
group by product_line
order by Avg_rating desc;

---------------------------------------------------------------------------------------------------------------------------------------------------------

----Sales--------

--1. Number of sales made in each time of the day 
--per week

SELECT
  time_of_the_day,
  COUNT(*) AS total_sales
FROM
  walmart_sales
WHERE
  day_name = 'Monday'
GROUP BY
  time_of_the_day
ORDER BY
  total_sales DESC;

------2.Which of the customer types brings the most revenue?---
select Customer_type,
sum(total) as Total_Revenue
from walmart_sales
group by customer_type
order by Total_Revenue desc;


---3. Which City has the largest
--- tax percentage/vat(Value Added Tax)?
SELECT
  city,
  AVG("Tax_5%") AS VAT
FROM
  walmart_sales
GROUP BY
  city
ORDER BY
  VAT desc;
  
----4. Which customer type pays the most in VAT?


SELECT
  customer_type,
  AVG("Tax_5%") AS VAT
FROM
  walmart_sales
GROUP BY
 Customer_type
ORDER BY
  VAT desc;
  
---------------------------------------------------
-------Customer-----

--1. How many Unique customer types does the data have?

select distinct customer_type
from walmart_sales;

--2. How many Unique payment method
--does the data have?

select distinct payment_method
from walmart_sales;

--which customer_type buys the most?

select  customer_type,

count(*) as customer_cnt

from walmart_sales

group by customer_type
order by customer_cnt;


----4. what is the gender of the most of the customers?
select gender,
count(*) as gender_cnt
from walmart_sales
group by gender
order by gender_cnt
desc;


----5. What is the gender distribution per branch?
select gender,branch,
count(*) as gender_cnt
from walmart_sales
where branch = 'C'
group by gender,branch
order by gender_cnt
desc;

----6. what time of the day do customers give most ratings?


select time_of_the_day,
AVG(rating) as avg_rating
from walmart_sales
group by time_of_the_day
order by avg_rating desc;

-----7. Which Time of the day do customer give most
----ratings per branch?

select time_of_the_day,branch,
AVG(rating) as avg_rating

from walmart_sales
where branch = 'C'
group by time_of_the_day,branch
order by avg_rating desc;

-----which day of the week has the best avg ratings?

select day_name,
AVG(rating) as Avg_rating
From walmart_sales
Group by day_name
order by avg_rating desc;

-----which day of the week has the best
---average ratings per branch

select day_name,branch,
AVG(rating) as Avg_rating
From walmart_sales
where branch = 'A'
Group by day_name, branch
order by avg_rating desc;


--------------------------------------------------------------------------------------------------------------------------------------
---Revenue and Profit calculations----
------1. $ COGS = unitsPrice * quantity $------

select * from walmart_sales;

-- Add a new column for COGS
ALTER TABLE walmart_sales
ADD COLUMN new_cogs DECIMAL(12, 4);


-- Update the new COGS column with the calculated values
UPDATE walmart_sales
SET new_cogs = (unit_price::numeric) * quantity;

-- Update the new COGS column with the calculated values
UPDATE walmart_sales
SET new_cogs = (unit_price::numeric) * (quantity::numeric);


---2. $ VAT = 5% * COGS $-------


-- Add a new column for VAT
ALTER TABLE walmart_sales
ADD COLUMN vat DECIMAL(12, 4);

-- Update the new VAT column with the calculated values
UPDATE walmart_sales
SET vat = 0.05 * cogs;

select * from walmart_sales;


