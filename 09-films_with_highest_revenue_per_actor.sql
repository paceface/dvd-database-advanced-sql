/*
Films with the most revenue per actor - revenue/number of actors
*/
with
	-- Get number of actors per film
	actor_count as
		(select f.film_id,
			f.title,
			count(fa.actor_id) as num_actors
		from film f
		join film_actor fa on fa.film_id = f. film_id
		group by f.film_id, f.title
		order by f.film_id),
	-- Get revenue of each film
	film_revenue as
		(select i.film_id,
			sum(p.amount) as gross_revenue
		from payment p
		join rental r on r.rental_id = p.rental_id
		join inventory i on i.inventory_id = r.inventory_id
		group by i.film_id
		order by i.film_id),
	-- Calculate revenue per film per actor
	film_rev_per_actor as
		(select ac.film_id,
			ac.title,
			ac.num_actors,
			fr.gross_revenue,
			fr.gross_revenue / ac.num_actors as rev_per_actor
		from actor_count ac
		join film_revenue fr on fr.film_id = ac.film_id)

select * from film_rev_per_actor order by rev_per_actor desc limit 5
