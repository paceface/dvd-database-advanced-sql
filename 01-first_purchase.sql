/*
What was the first purchase made by each customer?
*/

-- First get a list of all customer orders, in order asc
with first_orders as (
	select p.customer_id,
		p.payment_date,
		p.rental_id,
		-- If you wanted to get the most recent order you could order the below in descending order
		row_number() over(partition by p.customer_id order by p.payment_date) as row_num
	from payment p
)

-- The select the first item for each customer and join together all the pertinent information
select c.customer_id,
	c.first_name,
	c.last_name,
	fo.payment_date,
	f.title
from customer c
join first_orders fo on fo.customer_id = c.customer_id
join rental r on r.rental_id = fo.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
where row_num = 1
order by c.customer_id
