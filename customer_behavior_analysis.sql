-- combine menu_items table with order_details table#
-- top5 most ordered items and their category
with combined_table as 
(select a.*, b.item_name,b.category, b.price from order_details as a
	left join menu_items as b
    on a.item_id = b.menu_item_id)
    
select item_id,item_name, price, category, count(*) as ordered_times from combined_table 
group by item_id
having item_id is not null
order by ordered_times desc
limit 5;



-- the least ordered items and their category

with combined_table as 
(select a.*, b.item_name,b.category, b.price from order_details as a
	left join menu_items as b
    on a.item_id = b.menu_item_id
    where b.menu_item_id is not null)
    
select item_id,item_name, price, category, count(*) as ordered_times from combined_table 
group by item_id
order by ordered_times asc
limit 5;

-- top 5 orders that spent the most money#
with combined_table as 
(select a.*, b.item_name,b.category, b.price from order_details as a
	left join menu_items as b
    on a.item_id = b.menu_item_id
    where b.menu_item_id is not null)
    
select order_date,order_id, sum(price) as total_order_value from combined_table 
group by order_date, order_id
order by total_order_value desc
limit 5 ;


-- The details of the highest spend order. 
-- Which specific items in the highest spend order were purchased?
set @row_number = 0;
with combined_table as 
(select a.*, b.item_name,b.category, b.price from order_details as a
	left join menu_items as b
    on a.item_id = b.menu_item_id
    where b.menu_item_id is not null)
 , highest_spend_order as   
(select order_date,order_id, sum(price) as total_order_value from combined_table 
group by order_date, order_id
order by total_order_value desc
limit 1)


select (@row_number := @row_number + 1) as item_count, b.order_id, b.item_id, b.item_name, b.category, b.price  
from highest_spend_order as a
left join combined_table as b
on a.order_id = b.order_id;



-- Which category account for the highest percentage of order value in the highest spend order ?

with combined_table as 
(select a.*, b.item_name,b.category, b.price from order_details as a
	left join menu_items as b
    on a.item_id = b.menu_item_id
    where b.menu_item_id is not null)
 , highest_spend_order as   
(select order_date,order_id, sum(price) as total_order_value from combined_table 
group by order_date, order_id
order by total_order_value desc
limit 1)

, highest_spend_details as
(
select b.order_id, b.item_id, b.item_name, b.category, b.price  
from highest_spend_order as a
left join combined_table as b
on a.order_id = b.order_id)

select category, 
		sum(price) as total_per_cat, 
		concat(cast(100 * sum(price)/ sum(sum(price)) over() as decimal(18,2)),"%") as '% of total'
from highest_spend_details
group by category
order by total_per_cat desc;


-- highest number of orders/highest revenue/average order value by day of week
with combined_table as 
(select a.*, b.item_name,b.category, b.price 
	from order_details as a
	left join menu_items as b
    on a.item_id = b.menu_item_id
    where b.menu_item_id is not null)

select 
    case 
		when dayofweek(order_Date) = 1 then "Sunday"
        when dayofweek(order_Date) = 2 then "Monday"
        when dayofweek(order_Date) = 3 then "Tuesday"
        when dayofweek(order_Date) = 4 then "Wednesday"
        when dayofweek(order_Date) = 5 then "Thursday"
        when dayofweek(order_Date) = 6 then "Friday"
        when dayofweek(order_Date) = 7 then "Saturday"
        else ""
	end as Day_of_Week,
	count(distinct(order_id)) as total_orders,
	concat("$", sum(price)) as total_revenue,
    concat("$", cast(sum(price)/count(distinct(order_id)) as decimal(18,2))) as average_order_value
from combined_table
group by Day_of_Week
order by total_orders desc, total_revenue desc