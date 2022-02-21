/*
Calculate a running average of time between orders for each record and the previous 7
Calculate a running average of time between orders for each record and 3 records before and after that record
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

-- Running averages

select tbp.customer_id,
	tbp.payment_id,
	tbp.payment_date,
	round(tbp.hours_since,2) as hours_since,
	round(avg(tbp.hours_since) over (partition by tbp.customer_id order by tbp.payment_date rows between 7 preceding and 0 following),2) as avg_time_between_previous_7,
	round(avg(tbp.hours_since) over (partition by tbp.customer_id order by tbp.payment_date rows between 3 preceding and 3 following),2) as avg_time_between_plu_minus_3
from time_between_purchases tbp
