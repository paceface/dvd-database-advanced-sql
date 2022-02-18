/*
What are the the minimum, maximum, and average time between customer purchases?
*/

with
	current_previous_purchases as (
		select p.payment_id,
			p.customer_id,
			p.payment_date,
			--use payment_date to get previous payment_date for each customes' purchases
			lag(p.payment_date) over(partition by p.customer_id order by p.payment_date) as prior_date
		from payment p
		order by p.customer_id),
	time_between_purchases as (
		select cpp.payment_id,
			cpp.customer_id,
			cpp.payment_date,
			cpp.payment_date - cpp.prior_date as time_between,
			extract(epoch from cpp.payment_date - cpp.prior_date) / 3600 as hours_since --interval as hours since
		from current_previous_purchases cpp)

-- Summary metrics for the time between customer purchases

select tbp.customer_id,
	round(min(tbp.hours_since),2) as shortest_time_between,
	round(max(tbp.hours_since),2) as longest_time_between,
	round(avg(tbp.hours_since),2) as avg_time_between
from time_between_purchases tbp
group by tbp.customer_id
