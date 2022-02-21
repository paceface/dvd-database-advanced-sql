/*
Top five highest grossing actors
What percentage of customers rented at least one of their films
*/

with
	-- get gross sales for each actor
	actors_sales as
		(select a.actor_id,
			a.first_name,
			a.last_name,
			sum(p.amount) over(partition by a.actor_id) gross_sales,
			row_number() over(partition by a.actor_id) as row_num
		from actor a
		join film_actor fa on fa.actor_id = a.actor_id
		join film f on f.film_id = fa.film_id
		join inventory i on i.film_id = f.film_id
		join rental r on r.inventory_id = i.inventory_id
		join payment p on p.rental_id = r.rental_id
		order by a.actor_id, row_num),
	-- Top five highest grossing actors - the answer to the first question
	top5 as
		(select actor_id,
		 	first_name || ' ' || last_name as full_name,
			gross_sales
		from actors_sales
		where row_num = 1
		order by gross_sales desc
		limit 5),
	-- All films by these top 5 actors
	-- 183 results
	top_movies as
		(select f.film_id,
			f.title
		from top5 t5
		join film_actor fa on fa.actor_id = t5.actor_id
		join film f on f.film_id = fa.film_id
		group by f.film_id),
	-- All rental transactions
	-- 14596 results, 599 customers
	customer_rentals as
		(select c.customer_id,
			i.film_id
		from customer c
		join payment p on p.customer_id= c.customer_id
		join rental r on r.rental_id = p.rental_id
		join inventory i on i.inventory_id = r.inventory_id
		order by c.customer_id),
	-- customers who rented a movie with a top actor
	-- 591 results
	customer_top_movies as
		(select distinct cr.customer_id
		from customer_rentals cr
		where cr.film_id in
			(select tm.film_id
			from top_movies tm))

-- Top 5 Grossing actors
-- select * from top5

-- What percentage of customers rented at least one of their films
	select round((select count(customer_id) from customer_top_movies)::decimal / (select count(customer_id) from customer)::decimal * 100,2) as answer
