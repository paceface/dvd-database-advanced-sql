/*
Show the top 10% of movies by total sales
*/
with percentile_groups as (
	select f.film_id,
		f.title,
		sum(p.amount) as total_sales,
		--This splits the results into 100 groups
		ntile(100) over (order by sum(p.amount) desc) as percentile_rank
	from film f
		join inventory i on i.film_id = f.film_id
		join rental r on r.inventory_id = i.inventory_id
		join payment p on p.rental_id = r.rental_id
	group by f.film_id, f.title
	order by total_sales desc
)
select pr.film_id,
	pr.title,
	pr.total_sales,
	pr.percentile_rank
from percentile_groups pr
where percentile_rank <= 10
--Alternatively I could have done ntile(10) and and changed the where clause to percentile_rank = 1
--I like doing it this way, where the groups are broken up into percentiles, so I can easily change a the where clause to get a different group.
