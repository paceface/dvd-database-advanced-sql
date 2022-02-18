# DVD Rental Database - Advanced SQL queries
In this repo I am creating some reports using the Sakila Sample Database. It is a programmatically generate database for a fictitious DVD rental chain. The database is open source under the BSD License. The database can be downloaded at [here](https://www.postgresqltutorial.com/postgresql-sample-database/).

This will be more of a place for me to practice and document SQL than a portfolio project. I took a [Udemy course](https://www.udemy.com/course/advanced-applied-sql-for-business-intelligence-and-analytics/) where we used this dataset. The first files represent my work for that course, but I'll keep adding to it over time.

Here's a brief rundown of each file in this repo. The queries we written for a Postgres environment.

## What was the first purchase made by each customer?
*SQL used: CTE, window, partition, row_number(), join*
01-first_purchase.sql

## Customer Account Summary
*SQL used: CTE, window, partition, row_number(), array_agg(), join*
02-customer_account_summary.sql


## What are the the minimum, maximum, and average time between customer purchases?
*SQL used: CTE, lag, window, partition, aggregate functions*
03-time_between_customer_purchases.sql
