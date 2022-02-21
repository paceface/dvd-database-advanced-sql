/*
What are some of the characteristics of customer first purchases
*/


with
	--Get all first orders
	first_orders as (
		select t.customer_id,
			t.staff_id,
			t.rental_id,
			t.amount
		from (
			select p.*,
			row_number() over (partition by p.customer_id order by p.payment_date) as first_order
			from payment p) t
		where t.first_order = 1),
	--Get the store where these orders took place
	store_info as (
		select s.store_id,
			fo.customer_id
		from staff s
		join first_orders fo on fo.staff_id = s.staff_id
	),
	--Get details of the first movie rented by each customer
	first_movie as (
		select fo.customer_id,
			f.title,
			f.rating,
			l.name as language_name
		from first_orders fo
		join rental r on r.rental_id = fo.rental_id
		join inventory i on i.inventory_id = r.inventory_id
		join film f on f.film_id = i.film_id
		join language l on l.language_id = f.language_id
	)



-- How much did each customer spend on first orders
select fo.customer_id, fo.amount from first_orders fo

-- At which store did most customers place their first order
  --select si.store_id, count(si.*) as store_count from store_info si group by si.store_id

-- What rating is most popular for first orders
  --select fm.rating, count(fm.*)
  --from first_movie fm
  --group by fm.rating
  --order by count(fm.*) desc

-- What movie is most popular for first orders
  -- select fm.title, count(fm.*)
  -- from first_movie fm
  -- group by fm.title
  -- order by count(fm.*) desc

-- What film llanguage is most popular for first orders
  -- select fm.language_name, count(fm.*)
  -- from first_movie fm
  -- group by fm.language_name
  -- order by count(fm.*) desc
