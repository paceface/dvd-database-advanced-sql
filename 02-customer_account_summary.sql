/*
Customer wants a report with :
  - Buyer id
  - First order date
  - Most recent order date
  - Total money spent
  - Preferred movie rating
  - All ratings they rent from
*/

with
	payment_dates as(
		-- get all orders
		select p.customer_id, p.payment_date,
			--create a column of ascending order numbers
			row_number() OVER(partition by p.customer_id order by p.payment_date asc) as first_order,
			--create a column of descending order numbers
			row_number() over(partition by p.customer_id order by p.payment_date desc) as last_order
		from payment p),

	first_last as (
		-- get only first and last orders
		select pd.customer_id,
			pd.payment_date,
			pd.first_order,
			pd.last_order
		from payment_dates pd
		where pd.first_order = 1 or pd.last_order = 1),

	rental_details as (
		-- get film and rating for each order
		select r.customer_id,
			r.rental_date,
			f.title,
			f.rating
		from rental r
		join inventory i on r.inventory_id = i.inventory_id
		join film f on i.film_id = f.film_id),

	rating_pref as (
		-- get the most rented film rating from each customer
		select * from (
			select rd.customer_id,
				rd.rating as preferred_rating,
				count(*) as rating_count,
				row_number() over(partition by customer_id order by count(*) desc) as rental_rank
			from rental_details rd
			group by customer_id, rating
			order by customer_id)t
		where rental_rank = 1),

	rating_array as (
		-- combine all the rating that each customer rented from into an array
		select rd.customer_id,
			array_agg(distinct rd.rating) as rented_ratings
		from rental_details rd
		group by rd.customer_id)

-- put it all together to answer the customer's question
-- get columns for customer id, first date, most recent date, total spending, preferred_rating, rented_ratings
select fl.customer_id, max(fl.payment_date) as recent_order_date, min(fl.payment_date) as first_order_date,
	(select sum(amount) from payment p2 where p2.customer_id = fl.customer_id) as total_spending,
 	(select preferred_rating from rating_pref rp where rp.customer_id = fl.customer_id and rp.rental_rank = 1) as preferred_rating,
	(select rented_ratings from rating_array ra where ra.customer_id = fl.customer_id)
from first_last fl
group by fl.customer_id
order by fl.customer_id
