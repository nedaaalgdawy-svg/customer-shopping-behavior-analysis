-- ============================================================
-- BUSINESS QUESTIONS 
-- Project: Customer Shopping Behavior Analysis
-- ============================================================

-- Q1. What is the total revenue and the average purchase amount
--     for male and female customers?

USE customer_behavior;
GO

SELECT gender,
       SUM(purchase_amount) AS revenue,
       CAST(AVG(purchase_amount * 1.0) AS DECIMAL(10, 2)) AS avg_purchase
FROM dbo.shopping_behavior
GROUP BY gender;
-- Q2. How many customers used a discount but still spent above the average
--     purchase amount, and who are the top 10 spenders among them?
SELECT COUNT(*) AS customers_above_avg_with_discount
FROM dbo.shopping_behavior
WHERE discount_applied = 'Yes'
  AND purchase_amount > (SELECT AVG(purchase_amount * 1.0)
                         FROM dbo.shopping_behavior);

SELECT TOP 10
       customer_id,
       purchase_amount
FROM dbo.shopping_behavior
WHERE discount_applied = 'Yes'
  AND purchase_amount > (SELECT AVG(purchase_amount * 1.0)
                         FROM dbo.shopping_behavior)
ORDER BY purchase_amount DESC, customer_id;
-- Q3. What are the top 5 products with the highest average review rating?
SELECT TOP 5
       item_purchased,
       CAST(AVG(review_rating) AS DECIMAL(4,2)) AS [Average Product Rating]
FROM dbo.shopping_behavior
GROUP BY item_purchased
HAVING COUNT(*) >= 30
ORDER BY AVG(review_rating) DESC;
-- Q4. Compare the average purchase amount between Standard and Express shipping.
SELECT shipping_type,
       CAST(AVG(purchase_amount * 1.0) AS DECIMAL(10, 2)) AS avg_purchase,
       COUNT(*) AS [Orders]
FROM dbo.shopping_behavior
WHERE shipping_type IN ('Express', 'Standard')
GROUP BY shipping_type
ORDER BY avg_purchase DESC;

-- Q5. Do subscribed customers spend more? Compare average spend and total revenue
--     for subscribers vs non-subscribers.
SELECT subscription_status,
       COUNT(*) AS total_customers,
       CAST(AVG(purchase_amount * 1.0) AS DECIMAL(10, 2)) AS avg_purchase,
       CAST(SUM(purchase_amount) AS DECIMAL(10, 2)) AS total_revenue
FROM dbo.shopping_behavior
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- Q6. Which 5 products have the highest percentage of purchases made with a discount?
SELECT TOP 5
       item_purchased,
       CAST(AVG(CASE WHEN discount_applied = 'Yes' THEN 1.0 ELSE 0 END) * 100 AS DECIMAL(5,2)) AS discount_rate
FROM dbo.shopping_behavior
GROUP BY item_purchased
HAVING COUNT(*) >= 30
ORDER BY AVG(CASE WHEN discount_applied = 'Yes' THEN 1.0 ELSE 0 END) * 100 DESC;

-- Q7. How can customers be segmented by purchase frequency
--     (frequent / regular / occasional buyers), and how many customers are in each segment?
-- Q7: Segment customers by purchase frequency
-- Frequent   = Weekly + Fortnightly  (every 7-14 days)
-- Regular    = Monthly + Quarterly   (every 15-90 days)
-- Occasional = Annually              (once a yearWITH freq_segments AS (
    SELECT
        CASE
            WHEN purchases_frequency_days <= 14 THEN 'Frequent'
            WHEN purchases_frequency_days <= 90 THEN 'Regular'
            ELSE 'Occasional'
        END AS segment
    FROM dbo.shopping_behavior
)
SELECT
    segment,
    COUNT(*) AS customers,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS pct
FROM freq_segments
GROUP BY segment
ORDER BY customers DESC;)

-- Q8. What are the top 3 best-selling products in each category?
  WITH items_counts AS (
  SELECT
        category,
        item_purchased,
        COUNT(*) AS times_purchased,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(*) DESC, item_purchased   -- tie-breaker
        ) AS rn
    FROM dbo.shopping_behavior
    GROUP BY category, item_purchased
)
SELECT category, item_purchased, times_purchased, rn
FROM items_counts
WHERE rn <= 3
ORDER BY category, rn;

-- Q9: Are customers who purchase more frequently (e.g. weekly)
--     more likely to be subscribed than occasional buyers?
WITH freq_segments AS (
    SELECT
        CASE
            WHEN purchases_frequency_days <= 14 THEN 'Frequent'
            WHEN purchases_frequency_days <= 90 THEN 'Regular'
            ELSE 'Occasional'
        END AS segment,
        subscription_status
    FROM dbo.shopping_behavior
)
SELECT
    segment,
    COUNT(*) AS customers,
    SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) AS subscribers,
    SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS subscribers_pct
FROM freq_segments
GROUP BY segment
ORDER BY subscribers_pct DESC;


-- Q10. What is the revenue contribution of each age group?
SELECT
    age_group,
    SUM(purchase_amount) AS total_revenue,
    SUM(purchase_amount) * 100.0 / SUM(SUM(purchase_amount)) OVER () AS revenue_pct
FROM dbo.shopping_behavior
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Q11. Which states generate the highest revenue?
--      Show the top 10 states by total purchase amount.
SELECT TOP 10
       location,
       SUM(purchase_amount) AS total_revenue
FROM dbo.shopping_behavior
GROUP BY location
ORDER BY total_revenue DESC;
-- Q12. How does purchasing behavior differ across seasons?
--      Compare total revenue, number of purchases, and average purchase
--      amount for each season.
SELECT season,
       COUNT(*) AS total_purchases,
       CAST(AVG(purchase_amount * 1.0) AS DECIMAL(10, 2)) AS avg_purchase,
       SUM(purchase_amount) AS total_revenue
FROM dbo.shopping_behavior
GROUP BY season
ORDER BY total_revenue DESC;