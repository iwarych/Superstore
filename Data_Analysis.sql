-- Create a view to simplify queries

CREATE VIEW superstore_view AS
SELECT
    *,
    date_part('year', orderdate) AS order_year,
    date_part('month', orderdate) AS order_month,
    to_char(orderdate, 'Month') AS month_name,
    (profit / sales) * 100 AS profit_margin,
    shipdate - orderdate AS order_processing_time
FROM
    superstore

--Calculate month over month (MoM) sales change

SELECT
    order_year,
    order_month,
    month_name,
    round(sum(sales), 0) AS Monthly_Sales,
    round(sum(sales) - (lag(sum(sales), 1) OVER (ORDER BY order_year, order_month, month_name)), 0) AS sales_MoM,
	(round(sum(sales) - (lag(sum(sales), 1) OVER (ORDER BY order_year, order_month, month_name)), 0) / round(sum(sales), 0)) AS sales_MoM_perc
FROM
    superstore_view
GROUP BY
    order_year,
    order_month,
    month_name
ORDER BY
    order_year,
    order_month,
    month_name

--Calculate month over month (MoM) profit change

SELECT
    order_year,
    order_month,
    month_name,
    round(sum(profit), 0) AS Monthly_Profit,
    round(sum(profit) - (lag(sum(profit), 1) OVER (ORDER BY order_year, order_month, month_name)), 0) AS profit_MoM,
	(round(sum(profit) - (lag(sum(profit), 1) OVER (ORDER BY order_year, order_month, month_name)), 0) / round(sum(profit), 0)) AS profit_MoM_perc
FROM
    superstore_view
GROUP BY
    order_year,
    order_month,
    month_name
ORDER BY
    order_year,
    order_month,
    month_name

--Calculate year over year (YoY) sales change

SELECT
    order_year,
    round(sum(sales), 0) AS Annual_Sales,
    round(sum(sales) - (lag(sum(sales), 1) OVER (ORDER BY order_year)), 0) AS sales_YoY
FROM
    superstore_view
GROUP BY
    order_year
ORDER BY
    order_year

--Calculate year over year (YoY) profit change

SELECT
    order_year,
    round(sum(profit), 0) AS Annual_Profit,
    round(sum(profit) - (lag(sum(profit), 1) OVER (ORDER BY order_year)), 0) AS profit_YoY
FROM
    superstore_view
GROUP BY
    order_year
ORDER BY
    order_year

---Calculate average sales and profit for product category

SELECT
    category,
    avg(sales) AS average_sales_category,
    avg(profit) AS average_profit_category
FROM
    superstore_view
GROUP BY
    category

---Calculate average sales and profit for product subcategory

SELECT
    subcategory,
	order_year,
    avg(sales) AS average_sales_category,
    avg(profit) AS average_profit_category
FROM
    superstore_view
GROUP BY
    subcategory, order_year

---Calculate average sales and profit for region

SELECT
    region,
    avg(sales) AS average_sales_category,
    avg(profit) AS average_profit_category
FROM
    superstore_view
GROUP BY
    region

--Difference between order creation date and ship date

WITH base AS (
    SELECT
        *
    FROM
        superstore_view
)
SELECT
    shipmode,
    avg(order_processing_time) AS test,
    sum(sales) AS sales,
    sum(profit) AS profit
FROM
    base
GROUP BY
    shipmode
ORDER BY
    avg(order_processing_time) DESC

--Profit gain and loss

WITH profit_base AS (
    SELECT
        subcategory,
        region,
        sum(profit) AS total_profit,
        count(
            CASE WHEN profit < 0 THEN
                orderid
            ELSE
                NULL
            END) AS order_profit_loss,
        count(
            CASE WHEN profit = 0 THEN
                orderid
            ELSE
                NULL
            END) AS order_profit_zero,
        count(orderid) AS all_orders
    FROM
        superstore_view
    GROUP BY
        subcategory,
        region
)
SELECT
    subcategory,
    region,
    order_profit_loss,
    order_profit_zero,
    all_orders,
    total_profit,
    (order_profit_loss / all_orders::decimal) AS perc_orders_profit_loss,
    (order_profit_zero / all_orders::decimal) AS perc_orders_profit_zero
FROM
    profit_base
ORDER BY
    subcategory,
    total_profit DESC,
    region

--Count of new customers per month by region

WITH base AS (
    SELECT
        customerid,
		region,
        min(orderdate) AS first_order_date
    FROM
        superstore_view
    GROUP BY
		region,
        customerid
    ORDER BY
        customerid
)
SELECT
	region,
    date_part('year', first_order_date) AS year,
    date_part('month', first_order_date) AS month,
    to_char(first_order_date, 'Month') AS month_name,
    count(customerid)
FROM
    base
GROUP BY
	region,
    year,
    month,
    month_name
ORDER BY
	region,
    year,
    month,
    month_name

--regular customers - customers with more than one order in month by region


WITH customer_orders AS (
    SELECT
        customerid,
        order_year AS year,
        order_month AS month,
        count(orderid) AS monthly_orders
    FROM
        superstore_view
    GROUP BY
        customerid,
        year,
        month
    HAVING
        count(orderid) > 1
    ORDER BY
        customerid,
        year,
        month
)
SELECT
    co.year,
    co.month,
    s.region,
    count(co.customerid) AS customer_volume
FROM
    superstore_view AS s
    INNER JOIN customer_orders co ON s.customerid = co.customerid
GROUP BY
    s.region,
    co.year,
    co.month
ORDER BY
    co.year,
    co.month,
    customer_volume DESC















