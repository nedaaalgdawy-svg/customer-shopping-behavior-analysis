Customer Shopping Behavior — End-to-End Retail Analytics Project




A complete data analytics pipeline built from scratch: raw Kaggle data → cleaning in Python → business questions in SQL Server → interactive Power BI dashboard → printable PDF report.

Author: @nedaaalgdawy-svg

Dashboard Preview
1. Customer Overview

2. Revenue & Locations

3. Products & Shipping

Project Pipeline
Data preparation (Python / pandas) — data_preparation.ipynbEDA, cleaning and feature engineering: renamed columns to snake_case, removed the duplicated promo_code_used column (it was 100% identical to discount_applied), added age_group and purchases_frequency_days, and exported clean_shopping_behavior.csv (3,900 rows × 19 columns).
Business questions (SQL Server) — business_questions_bilingual (1).sqlSQL queries answering 12 business questions about customers, revenue, products and shipping.
Dashboard (Power BI Desktop) — CSB_Shopping_Insights_Dashboard.pbixA 3-page interactive dashboard with slicers for gender, season, category and age group.
Report (PDF) — CSB_Shopping_Insights_Dashboard.pdfPrintable version of the dashboard (cover + 3 pages).
Dashboard Pages
Page	Questions answered
Customer Overview	Gender split, subscribers vs non-subscribers, purchase frequency, subscription rate by frequency, spend by age
Revenue & Locations	Revenue by season, revenue by age group, revenue by state (map)
Products & Shipping	Top 3 items per category, top 5 rated products, top 5 discount rates, average spend by shipping type
Key Insights
Male customers drive 68% of purchases, yet only 27% are subscribed — and the subscription rate stays nearly flat (26%–28%) across every purchase-frequency segment.
Every subscriber and every discounted purchase in this dataset is male (1,053 subscribers, 1,677 discounted purchases).
Revenue is balanced across age groups (23.9%–26.7%); Fall leads all seasons with $60,018 (25.8% of revenue).
Montana, Illinois and California top state revenues.
Blouses, Pants and Jewelry lead sales with 171 purchases each; Gloves take the best reviews (3.86).
Express shoppers spend about $2 more per order than Standard ones — a descriptive difference, not statistically significant.
Repository Files
File	Description
clean_shopping_behavior.csv	Cleaned dataset — 3,900 rows × 19 columns
data_preparation.ipynb	Python EDA & data preparation notebook
business_questions_bilingual (1).sql	SQL queries answering the business questions
CSB_Shopping_Insights_Dashboard.pbix	Power BI dashboard (interactive)
CSB_Shopping_Insights_Dashboard.pdf	Dashboard PDF report
Note: the .pbix was built on Power BI Desktop against SQL Server — if you open it locally, re-map the data source or point it to clean_shopping_behavior.csv.

About the Data
The dataset is a 3,900-row retail purchases dataset from Kaggle and it is synthetic (created for learning purposes). Every figure shown in the dashboard was verified against the data with pandas checksums.
