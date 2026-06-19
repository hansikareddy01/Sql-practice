--window function rownumber()
--assigning numbers to orders
 select order_id,order_purchase_timestamp ,
row_number() over(
 order by order_purchase_timestamp
) as rn from orders 
--assigning number to orders for each state for group so we use partition
select customer_id, customer_state , row_number() over(
partition by customer_state
order by customer_id
) as rn from customers
--find latest order of each customer
with cte as(
select order_id,customer_id,order_purchase_timestamp ,row_number() over(
partition by customer_id
order by order_purchase_timestamp desc
) as rn from orders
)
select * from cte where rn=1
-- find top 3 most expensive items in each order
with expen as(
select order_id, product_id,order_item_id ,price, row_number()
over(
partition by order_id 
order by price desc
)as rn from order_items)
select * from expen where rn<=3
--find top 5 customers from each state based on number of orders
with top5 as(select customer_unique_id ,customer_state , row_number over(
partition by customer_state order by count()
))
