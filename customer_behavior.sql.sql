select * from customer;
--1]what is a total revanue genarated by male vs female?
select gender, sum (purchase_amount) as revanue
from customer
group by gender ;
--which cusstomer used a discount but still spend more than the avrage purchase amount?
SELECT customer_id, purchased_amount
FROM customer
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (
      SELECT AVG(purchase_amount)
      FROM customer
  );
  -- which are the top 5 products with the highest avrage rating ?
  select item_purchased,round(avg (review_rating::numeric),2) as "avrage _product_rating"
  from customer 
  group by (item_purchased)
  order by avg (review_rating) desc
  limit 5;
  -- compare the "avrage purches amount" between "standard" and "express shipping"
  select shipping_type,round(avg(purchase_amount::numeric),2) as "avrage_purchase_amount"
  from customer
  where shipping_type in ('Standard','express_shipping')
  group by shipping_type;
  --do subsribed customer send more ? compare avrage spend and total revenue between subscriber and 
  --non subscribers 

select subscription_status,
        count(customer_id) as "customer_id",
        round(avg(purchase_amount),2) as "avrage_purchase",
		round(sum(purchase_amount),2) as "sum_of_puchase"
		from customer
		group by (subscription_status);
-- which 5 products are higher purches with discount applied 
select 
        item_purchased,
        COUNT(*) as total_purchases
from customer
where discount_applied='Yes'
group by item_purchaseddesc
order by total_purchases 
limit 5;
SELECT
    item_purchased,
    COUNT(*) AS total_purchases
FROM customer
WHERE discount_applied = 'Yes'
GROUP BY item_purchased
ORDER BY total_purchases DESC
LIMIT 5;
--.........................
-- segment customers into new returning and loyal based on their total number of privious purches
--and show the count of each segment?
--जेव्हा प्रश्नात असे शब्द असतात:Segment,Categorize,Classify,Bucket
---->                              	think on case,when suddenly
select 
case 
  when previous_purchases=0 then 'new'
  when previous_purchases between 1 and 10 then 'returning'
  else 'loyal'
  end as customer_segment,
 count(*) as total_customers
from customer 
group by customer_segment ;

--cte quary
with customer_type as (
select customer_id ,previous_purchases,
case
   when previous_purchases =1 then 'new'
   when previous_purchases  between 2 and 10 then 'returning'
   else 'loyal'
   end as customer_segment
from customer
)
select customer_segment ,count (*) as number_of_customers 
from customer_type
group by customer_segment;












  
--........................
--जेव्हा प्रश्नात असे शब्द असतात:
--How many
--Count
--Total customers
--        तेव्हा COUNT(*).
--........................
--Each segment
--Each category
--Each department
--        तेव्हा GROUP BY.
--........................

--what are the top 3 most purchesed products within each category 
WITH product_sales AS (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS total_purchases
    FROM customer
    GROUP BY category, item_purchased
),

ranked_products AS (
    SELECT
        category,
        item_purchased,
        total_purchases,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_purchases DESC
        ) AS rn
    FROM product_sales
)

SELECT
    category,
    item_purchased,
    total_purchases
FROM ranked_products
WHERE rn <= 3
ORDER BY category, rn;
---Top N overall → ORDER BY ... DESC LIMIT N
--Top N within each group → ROW_NUMBER() / RANK() + PARTITION BY


-- ARE customers who are repeat buyers(more than 5 privious purches)also likely to subscribe 
select subscription_status,
count(customer_id) AS "repeat_buyers"
from customer 
where previous_purchases >5
group by subscription_status

-- what is revenue contribution of each age group ?
SELECT
    "age group",
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY "age group"
ORDER BY total_revenue DESC;







  
