-- Explore the orders_details table#


-- the date range of this table#
select min(order_date) as start_date,
		max(order_date) as end_date
 from order_details;
 
 
 
 
 
 
 
-- number of orders and items were made within this date range#

select count(distinct(order_id)) as total_orders,
		count(order_details_id) as total_items
from order_details;


-- orders that had the most number of items#
select order_id, count(*) as num_of_items
from order_details
group by order_id
order by num_of_items desc;


-- orders that had more than 12 items#
with orders_greater12items as
(select order_id, count(*) as num_of_items
from order_details 
group by order_id
having num_of_items > 12
order by num_of_items desc)

select count(*) as number_of_orders_has_higher_12_items 
from orders_greater12items;



