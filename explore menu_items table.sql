-- Explore the menu items table#

-- the number of items on the menu#
select distinct( count(menu_item_id)) as total_menu_items 
from menu_items;



-- the most expensive items on the menu_items#
select menu_item_id, item_name,price
from menu_items
order by price desc
;


-- the least expensive items on the menu_items#
select menu_item_id, item_name,price
from menu_items
order by price asc
;

-- Number of Italian dishes on the menu#
select category, count(*) as items_per_category
from menu_items
where category = "Italian"
group by category;




-- the least expensive Italian dishes on the menu#
select menu_item_id, item_name, category,price
from menu_items
where category = "Italian"
order by price asc;



-- the most expensive Italian dishes on the menu#
select menu_item_id, item_name, category,price
from menu_items
where category = "Italian"
order by price desc;


-- Number of dishes and average price in each category#
select category, 
		count(*) as items_per_category, 
        cast(avg(price) as decimal(18,2)) as average_price
from menu_items
group by category
order by items_per_category asc;

