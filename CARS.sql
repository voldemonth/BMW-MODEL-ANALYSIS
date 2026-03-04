


drop database if exists cars;
create database cars;
use cars;

show columns from bmw_3;
select count(*) from bmw_3;

-- 1 AVG bmw car price per model

select model ,avg(price)as avg_car_price  from bmw_3
group by model
order by avg_car_price  desc ;

-- INSIGHT:
  -- Shows which models are premium vs budget.
 -- Higher avg price → luxury positioning.
 -- Lower avg price → mass market / older stock.


-- 2 Most Expensive Car Model
select  model , max(PRICE)  as highest_price from bmw_3
group by model
order by  highest_price  desc
limit 1;
 -- Insight:
 -- Identifies the top luxury model.
 -- Might represent a high-end trim, special edition, or latest year




--  3 Avg Price Per Year
select  model,year, avg(price) as avg_price from bmw_3
group by  year , model
order by model ,year;

-- INSIGHT :
 -- Shows how each model’s price changes yearly.
 -- If price increases each year → strong demand.
 -- If decreases → depreciation or weak demand.





--  4 mileage vs year
select  avg(mileage) as avg_mileage , year  from bmw_3
group by year
order by year ;
 -- INSIGHT:
 -- Older cars should logically have higher mileage.
 -- If recent year has high mileage → maybe used car market data.


--  5  Top 10  Lowest price Model
select model , avg(mileage) as mileage , avg(price) as price     from bmw_3
group by model
order by   price  , mileage desc
limit 10 ;
-- Insight:
-- Older cars should logically have higher mileage.
-- If recent year has high mileage → maybe used car market data.



-- 6   Avg price trend over year by year

select  model , avg(price) as price , year  from bmw_3
group by  year ,model
order by year , price ;

 -- Insight:
 -- Shows overall pricing direction.
 -- If average price rising yearly → inflation or brand premium increase.
 -- If falling → market competition.




-- 7  price diffrence  year by year

SELECT model,year,price,
    LAG(price) OVER (PARTITION BY model ORDER BY year) AS previous_year_price,
    price - LAG(price) OVER (PARTITION BY model ORDER BY year) AS price_difference
FROM bmw_3
ORDER BY model, year;

-- Insight:
 -- Exact increase or decrease amount.
 -- Sharp jump shows → new generation launch.
-- Sharp drop shows → model discontinuation or resale effect.


 -- 8 Dynamic Categorization of Cars Using SQL CASE

 select model ,price, mileage ,
 case
 when mileage >= 23303 then 'high mileage'
 when mileage  between 15706 and 22543  then  'medium mileage'
 else 'low mileage'
 end as  mileage_category
 from bmw_3
  group by  model , price, mileage ,
  case
   when mileage >= 23303 then 'high mileage'
 when mileage  between 15706 and 22543  then  'medium mileage'
 else 'low mileage'
 end
 order by price ;
 -- Insight:

-- Segments cars into usage categories.
-- Helps buyer target:
-- Low mileage → almost new
-- High mileage → budget option



 -- 9 TOTAL  PROFIT  EARNED BY PER  CAR MODEL

select   model, sum(price) as revenue , sum(tax) as total_tax_paid   , sum(price)-sum(tax) profit from bmw_3
group by model
order by total_tax_paid desc ;

-- INSIGHT :

-- Shows which model generates most revenue.
-- Helps identify most profitable line.



-- 10   GROWTH PERCENTAGE PER YEAR
SELECT
    model,
    year,
    AVG(price) AS avg_price,

    LAG(AVG(price)) OVER (
        PARTITION BY model
        ORDER BY year
    ) AS previous_year_price,

    ROUND(
        (
            (AVG(price) - LAG(AVG(price)) OVER (
                PARTITION BY model
                ORDER BY year
            ))
            / LAG(AVG(price)) OVER (
                PARTITION BY model
                ORDER BY year
            )
        ) * 100
    , 2) AS growth_percentage

FROM bmw_3
GROUP BY model, year
ORDER BY model, year;

-- Insight:
-- Shows % increase or decrease in price.



