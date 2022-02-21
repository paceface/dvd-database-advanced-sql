/*
Computing LTV Summary Metrics Using Correlated Subqueries

Case Study:
  If we wanted first order sales, first 7 day sales and first 14 day sales, how can we accomplish this using SQL
  You can easily filter globally on dates, but each customer has a fixed starting point for each date range bracket
  The answer = correlated subqueries

*/

with
	--Get first order date
	first_order as
		(select q1.*
		 from
			(select p.customer_id,
				p.payment_date,
				row_number() over(partition by customer_id order by p.payment_date) as row_num
			from payment p) q1
		where q1.row_num = 1),
	--Get sum of first 7 and 14 sales
	interval_sales as
		(select fo.customer_id,
		 	fo.payment_date,
			--Sum of first 7 sales
		 	(select sum(p2.amount)
			 from payment p2
			 where p2.customer_id = fo.customer_id
				--Since this inner query is using a value {fo.payment_date} from the outer query, this is a acorrelated subquery
			 	and p2.payment_date between fo.payment_date and fo.payment_date + interval '7 days') as first7_sales,
			--Sum of first 14 sales
		 	(select sum(p2.amount)
			 from payment p2
			 where p2.customer_id = fo.customer_id
				--Correlated subquery
			 	and p2.payment_date between fo.payment_date and fo.payment_date + interval '14 days') as first14_sales,
			(select sum(p2.amount)
			 from payment p2
			 where p2.customer_id = fo.customer_id) as LTV
		from first_order fo)

--Bring it all together and display metrics gathered
select i_s.customer_id,
	i_s.payment_date as first_order_date,
	i_s.first7_sales,
	--What percentage of sales do their first 7 sales represent
	i_s.first7_sales / i_s.ltv * 100 as first7_percent,
	i_s.first14_sales,
	i_s.first14_sales / i_s.ltv * 100 as first14_percent,
	i_s.ltv
from interval_sales i_s
