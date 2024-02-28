-- Data Wrangling

create database walmartsalesanalysis;
use walmartsalesanalysis;

Create table Sales (
	invoice_id varchar(30) not null primary key, 
    branch varchar(2) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date date not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_percentage float(11,9) not null,
    gross_income decimal(12,4) not null,
    rating float(2,1) 
);

desc sales;
select * from sales;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Feature Engineering Part

-- Adding Time of the day column

-- exploring the column
select time,
	(Case
		when time between "00:00:00" and "12:00:00" then "Morning"
		when time between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end
	) as time_of_day
 from sales;
 
 -- adding the column 
 alter table sales add column time_of_day varchar(20);

-- adding data into the column
update sales
set time_of_day = (
	Case
		when time between "00:00:00" and "12:00:00" then "Morning"
		when time between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end
);

select time_of_day from sales;



-- Adding day_name column

-- exploring the column
select date from sales;

select dayname(date) from sales;

-- adding the column dayname as Day 
alter table sales add column Day varchar(10);

-- adding data into the column
update sales 
set Day = dayname(date);

select date, day from sales;



-- adding month column

-- exploring the date column
select date, monthname(date) from sales; 

-- adding month column
alter table sales add column month varchar(15);

-- adding data into the month column
update sales
set month = monthname(date);

select date, month from sales;



-- --------------------------------------------------------------------------- 
-- --------------------- Exploratory data analysis --------------------------- 

-- --------------------- A. Product Analysis ---------------------------------
-- -----------------------Some of the questions from the data ----------------
-- 1. How many unique cities data have?
select distinct city from sales; 
-- 3 cities, a. Yangon, b. Naypyitaw, c. Mandalay

-- 2. in which city is each branch?
select distinct branch from sales;
select distinct branch, city from sales;
-- we have A branch in Yangon, B branch in Naypyitaw and C branch in Mandalay

-- 3. how many unique product line data have?
select count(distinct product_line) from sales;
-- 6 types

-- 4. What is the most common payment method
select payment_method, count(payment_method) as count from sales group by payment_method order by count desc;
-- cash

-- 5. what is the total revenue by month
select month, sum(total) as total_revenue from sales group by month order by total_revenue desc;

-- 6. Which month has the largest COGS?
select month, sum(cogs) cogs from sales group by month order by cogs desc;

-- 7. which product line has the largest revenue?
select distinct product_line, sum(total) as revenue from sales group by product_line order by revenue desc;

-- 8. Which city has the largest revenue?
select branch, city, sum(total) as revenue from sales group by city, branch order by revenue desc;

-- 9. Which product line has the largest VAT?
select distinct product_line, avg(VAT) as VAT from sales group by product_line order by VAT desc;

-- 10. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- 11. Which branch sold more products than average product sold?
select branch, sum(quantity) as qty from sales group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- 12. What is the most common product line by gender?
select gender, product_line, count(product_line) as total_count from sales group by gender, product_line order by total_count desc;

-- 13. What is the average rating of each product?
select product_line, round(avg(rating),2) as rating from sales group by product_line order by rating desc;



-- --------------------- B. Sales Analysis -------------------------
-- ------------ Some of the insigths from the data -----------------

-- 1. Number of sales made in each time  of the day per weekday ?
select time_of_day, count(*) as total_sales from sales group by time_of_day order by total_sales;

-- for specific day
select time_of_day,
count(*) as total_sales from sales
where day = "Sunday"
group by time_of_day order by total_sales;
 
-- 2. Which of the customer type brings the most revenue ?
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

-- 3. which city has the largest tax percent/ VAT ?
select city, avg(vat) as VAT from sales group by city order by VAT desc;

-- 4. Which customer type pays the most in VAT?
select customer_type, max(VAT) as VAT from sales group by customer_type order by VAT desc;



-- ----------- C. Customer Analysis ----------------------
-- -------- Some of the questions ------------------------
-- 1. How many unique customer types does the data have?
select distinct customer_type from sales;

-- 2. How many unique payment methods does the data have?
select distinct payment_method from sales;

-- 3. What is the most common customer type?
select max(customer_type) as common_customers from sales;

-- 4. Which customer type byus the most?
select customer_type, count(*) as Most_buying from sales group by customer_type order by Most_buying desc;

-- 5. What is the gender of most of the customers?
select gender, count(*) as Most_buyer from sales group by gender order by Most_buyer desc;

-- 6. What is the gender distribution per branch?
select gender, 
count(*) as Most_buyer 
from sales
where branch = "C" 
group by gender order by Most_buyer desc;

-- 7. Which time of the day do customers give most ratings?
select time_of_day,
avg(rating) as rating
from sales group by time_of_day 
order by rating desc;

-- 8. Which time of the day do customers give most ratings per branch?
select time_of_day,
avg(rating) as rating
from sales 
where branch = "A"
group by time_of_day 
order by rating desc;

-- 9. Which day of the week has the best avg ratings?
select day,
avg(rating) as avg_rating
from sales
group by day
order by avg_rating desc;

-- 10. Which day of the week has the best average ratings per branch?
select day,
avg(rating) as avg_rating
from sales
where branch = 'B'
group by day
order by avg_rating desc;
