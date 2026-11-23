-- Running MySQL based data exploration and analysis

CREATE DATABASE finance;

USE finance;

-- Tables imported using import wizard

RENAME TABLE cc_data_ TO cc_data;

SET SQL_SAFE_UPDATES=0;

ALTER TABLE cc_data
MODIFY COLUMN cc_num VARCHAR(30),
MODIFY COLUMN zip VARCHAR(10);

ALTER TABLE location_data
MODIFY COLUMN cc_num VARCHAR(30);

-- Calculate the total number of transactions in the cc_data table

SELECT 
COUNT(trans_num)
FROM cc_data;

-- Identify the top 10 most frequent merchants in the cc_data table

SELECT 
merchant,
COUNT(trans_num) AS total_transactions
FROM cc_data
GROUP BY merchant
ORDER BY COUNT(trans_num) DESC
LIMIT 10;

-- Find the average transaction amount for each category of transactions in the cc_data table

SELECT 
category,
AVG(amt) AS avg_amount
FROM cc_data
GROUP BY category;

-- Determine the number of fraudulent transactions and the percentage of total transactions that they represent

SELECT
COUNT(CASE WHEN is_fraud = 1 THEN 1 END) AS fraud_transactions,
ROUND(
COUNT(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(*),
2
) AS fraud_percentage
FROM cc_data;

-- Join the cc_data and location_data tables to identify the latitude and longitude of each transaction

SELECT
c.trans_num,
l.lat,
l.long
FROM location_data AS l
INNER JOIN cc_data AS c
ON l.cc_num = c.cc_num;

-- Identify the city with the highest population in the location_data table

SELECT
city,
city_pop
FROM cc_data
ORDER BY city_pop DESC
LIMIT 1;

-- Find the earliest and latest transaction dates in the cc_data table

DESCRIBE cc_data;

ALTER TABLE cc_data
ADD COLUMN trans_datetime DATETIME;

UPDATE cc_data
SET trans_datetime =
STR_TO_DATE(trans_date_trans_time, '%d-%m-%Y %H:%i');
    
SELECT
MIN(trans_datetime) AS earliest_transaction,
MAX(trans_datetime) AS latest_transaction
FROM cc_data;

-- What is the total amount spent across all transactions on the cc_data table?

SELECT 
SUM(amt) AS total_amount_spent
FROM cc_data;

-- How many transactions occurred in each category in the cc_data table?

SELECT 
category,
COUNT(trans_num) AS total_transactions
FROM cc_data
GROUP BY category;

-- What is the average transaction amount for each gender in the cc_data table?

SELECT 
gender,
AVG(amt) AS average_amount
FROM cc_data
GROUP BY gender;

-- Which day of the week has the highest average transaction amount in the cc_data table?

SELECT
DAYNAME(trans_datetime) AS day_of_week,
AVG(amt) AS average_amount
FROM cc_data
GROUP BY DAYNAME(trans_datetime)
ORDER BY average_amount DESC
LIMIT 1;

-- SUMMARY:

