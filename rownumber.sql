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
