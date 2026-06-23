--rank() function
-- the rank number differs from rownumber function rank number 
--q1 rank products based on their price
select product_id, rank() over(
order by price desc
)as rn from order_items
--q2 rank customers based on their total spend
with total as(select customer_unique_id,sum(payment_value) as total_spending
from customrs c join orders o on c.customer_id=o.customer_id
join order_payments op on op.order_id=o.order_id 
group by customer_unique_id
)
select *,rank() over(
order by total_spending desc
) as rn from total
--q3 rank customers from each state based on their total spend
with total as(select customer_state,customer_unique_id,sum(payment_value) as total_spending
from customers c join orders o on c.customer_id=o.customer_id
join order_payments op on op.order_id=o.order_id 
group by customer_unique_id,customer_state
)
select *,rank() over(
partition by customer_state
order by total_spending desc
) as rn from total
--q4 rank product category according to price
select product_category_name , price , rank() over(
partition by product_category_name order by price desc
) as rn from products p join order_items oi on p.product_id=oi.product_id
--q5 find customer of each state where rank number is 1 
with total as(select customer_state,customer_unique_id,sum(payment_value) as total_spending
from customers c join orders o on c.customer_id=o.customer_id
join order_payments op on op.order_id=o.order_id 
group by customer_unique_id,customer_state
)
, ranked as(
select * , rank() over(
partition by customer_state
order by total_spending desc
) as rn from total
)
select * from ranked where rn=1

