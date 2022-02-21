/*
Does the first rating rented from predict lifetime value?
*/


with
	--Sort all orders by order date, partioned by customer
	pay_order as
		(select p.*,
			row_number() over (partition by p.customer_id order by p.payment_date) as p_order
		from payment p),
	--Get just the first orders for each customer
	first_order as
		(select po.payment_id,
			po.customer_id,
			po.rental_id
		from pay_order po
		where po.p_order = 1),
	--Get the rating of the first movie rented by each customer
	first_rating as
		(select fo.*,
			f.film_id,
			f.title,
			f.rating
		from first_order fo
		join rental r on r.rental_id = fo.rental_id
		join inventory i on i.inventory_id = r.inventory_id
		join film f on f.film_id = i.film_id),
	-- get each customer's total spend, and subsequent number of rentals
	total_spending as
		(select p.customer_id,
			sum(p.amount) as total_spend,
		 	count(p.*) - 1 as subsequent_rentals
		from payment p
		group by p.customer_id),
	-- join spending and rating data
	customer_spend as
		(select fr.customer_id,
			fr.rating,
			ts.total_spend,
			ts.subsequent_rentals
		from first_rating fr
		join total_spending ts on ts.customer_id = fr.customer_id),
	-- get count, total and average spend for each rating, and subsequent rentals
	rating_count as
		(select fr.rating,
			count(fr.*) as rating_count,
		 	sum(cs.total_spend) as total_spend,
		 	avg(cs.total_spend) as avg_spend,
		 	sum(cs.subsequent_rentals) as total_subsequent_rentals,
			avg(cs.subsequent_rentals) as avg_subsequent_rentals
		from first_rating fr
		join customer_spend cs on cs.customer_id = fr.customer_id
		group by fr.rating)

select * from rating_count order by avg_spend desc
