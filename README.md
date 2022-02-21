# DVD Rental Database - Advanced SQL queries
In this repo I am creating some reports using the Sakila Sample Database. It is a programmatically generate database for a fictitious DVD rental chain. The database is open source under the BSD License. The database can be downloaded at [here](https://www.postgresqltutorial.com/postgresql-sample-database/).

This will be more of a place for me to practice and document SQL than a portfolio project. I took a [Udemy course](https://www.udemy.com/course/advanced-applied-sql-for-business-intelligence-and-analytics/) where we used this dataset. The first files represent my work for that course, but I'll keep adding to it over time.

SQL Skills Featured
- CTE
- Window Functions (lag, row_number, ntile,)
- Partition
- Join
- Correlated subquery

Here's a brief rundown of each file in this repo. The queries we written for a Postgres environment.

## What was the first purchase made by each customer?

*SQL used: CTE, window, partition, row_number(), join*

[01-first_purchase.sql](01-first_purchase.sql)

## Customer Account Summary

*SQL used: CTE, window, partition, row_number(), array_agg(), join*

[02-customer_account_summary.sql](02-customer_account_summary.sql)

## What are the the minimum, maximum, and average time between customer purchases?

*SQL used: CTE, lag, window, partition, aggregate functions*

[03-time_between_customer_purchases.sql](03-time_between_customer_purchases.sql)

## Calculate some running averages

*SQL used: CTE, lag, window, partition, aggregate functions*

[04-running_avg_time_between_customer_purchases.sql](04-running_avg_time_between_customer_purchases.sql)

## Split results into equal groups

*SQL used: CTE, ntile, window, join, aggregate functions*

[05-distribute_rows_into_equal_groups.sql](05-distribute_rows_into_equal_groups.sql)

## What are some of the characteristics of customer first purchases?

*SQL used: CTE, window, partition, row_number(), join, aggregate functions*

[06-first_purchase_analysis.sql](06-first_purchase_analysis.sql)

## Does the first rating rented from predict lifetime value?

*SQL used: CTE, window, partition, row_number(), join, aggregate functions*

[07-lifetime-values-based-on-rating-first-order.sql](07-lifetime-values-based-on-rating-first-order.sql)

## Top grossing actors

*SQL used: CTE, window, partition, row_number(), join, aggregate functions, where in*

[08-highest_grossing_actors.sql](08-highest_grossing_actors.sql)

## Films with the most revenue per actor - revenue/number of actors

*SQL used: CTE, subquery, join, aggregate functions*

[09-films_with_highest_revenue_per_actor.sql](09-films_with_highest_revenue_per_actor.sql)

## First 7 and 14 sales sums for each customer, as a percent of total lifetime sales of that customer

*SQL used: CTE, correlated subquery, window, partition, join, aggregate functions*

[10-first_x_sales.sql](10-first_x_sales.sql)

## Acquisition cost and profitability analysis

*SQL used: CTE, join, aggregate functions*

[11-acquisition_and_profit_analysis.sql](11-acquisition_and_profit_analysis.sql)
