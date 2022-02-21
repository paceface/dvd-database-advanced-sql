/*
Acquisition cost and profitability analysis
*/
with
	--How many acquisitions did each channel generate
	acquisitions_per_channel as (
		select cs.traffic_sources,
			count(cs.traffic_sources) as acquisitions
		from customer_sources cs
		group by cs.traffic_sources),
	--How much was spent by customers that were acquired by each channel
	customer_spend_per_channel as(
		select cs.traffic_sources,
			sum(p.amount) as total_cust_spend
		from customer_sources cs
		join payment p on p.customer_id = cs.customer_id
		group by cs.traffic_sources)

select ssa.spend_source,
	--Advertising spent on that channel
	ssa.spend::money,
	--Visits that channel generated
	ssa.visits,
	--Acquisition that channel generated
	apc.acquisitions,
	--Acquisition vs visits
	(apc.acquisitions::numeric / ssa.visits::numeric)*100 as acquisition_rate,
	--Cost per acquisition
	(ssa.spend/apc.acquisitions)::money as cpa,
	--Total money spent by customers acquired through that channel
	cspc.total_cust_spend::money,
	case
		when ssa.spend = 0 then 0
		else cspc.total_cust_spend/ssa.spend
	--Revenue vs Cost of acquisition
	end roi
from source_spend_all ssa
join acquisitions_per_channel apc on apc.traffic_sources = ssa.spend_source
join customer_spend_per_channel cspc on cspc.traffic_sources = ssa.spend_source
