SELECT * FROM crm_database.sales_pipeline;
/* 1. Total Sales. 
I focus on the closed deals (where the deal stage is " Won") 
and sum the close_value from the sales_pipeline table.
*/
SELECT
SUM(close_value) AS Total_sales
FROM sales_pipeline
WHERE deal_stage = "Won";

-- 2. Total Products. I count the unique entries in the product column from the products table.Using Distinct
SELECT COUNT(DISTINCT product) AS Total_products
FROM products;


/* 3. To calculate the Average sales per quarter
Group the sales data by each quarter.
Calculate the total sales for each quarter.
Then, calculate the average of those totals.
WITH QuarterlySales: The Common Table Expression (CTE) calculates the total sales for each quarter.
This assumes that the sales_pipeline table contains the close_date and close_value, and 
I  only want to consider closed deals (deals where the stage is "Closed Won").
*/
WITH QuarterlySales AS (
SELECT
EXTRACT(Year FROM close_date) AS Year,
EXTRACT(Quarter FROM close_date) AS Quarter,
SUM(close_value) AS Total_Sales
FROM sales_pipeline
WHERE deal_stage = "Won"
GROUP BY EXTRACT(Year FROM close_date), EXTRACT(Quarter FROM close_date)
)
SELECT AVG(Total_Sales) AS Average_sales_perQuarter
FROM QuarterlySales;

/* 4. Total Sales by Quarter using the sales_pipeline table to get the sales for each quarter
filtering for deals that were closed as "WON"
*/
SELECT
EXTRACT(YEAR FROM close_date) AS Year,
EXTRACT(QUARTER FROM close_date) AS Quarter,
SUM(close_value) AS Total_sales
FROM sales_pipeline
WHERE deal_stage = "Won"
GROUP BY EXTRACT(YEAR FROM close_date), EXTRACT(QUARTER FROM close_date)
ORDER BY Year, Quarter;

-- . To Find the total number of sales opportunities created each quarter
SELECT
EXTRACT(YEAR FROM close_date) AS Year,
EXTRACT(QUARTER FROM close_date) AS Quarter,
COUNT(opportunity_id) AS Total_opportunity FROM sales_pipeline
GROUP BY EXTRACT(YEAR FROM close_date), EXTRACT(QUARTER FROM close_date)
ORDER BY Year, Quarter;

/* 5. To find the performance by  Top 10 sales Agent  for each quarter using JOIN
Linking the sales_pipeline with the sales team table to get the performance by sales agent
*/
SELECT
st.sales_agent,
EXTRACT(YEAR FROM sp.close_date) AS Year,
EXTRACT(QUARTER FROM sp.close_date) AS Quarter,
SUM(sp.close_value) AS Total_sales
FROM sales_pipeline sp
JOIN sales_teams st 
ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage = "Won" 
GROUP BY st.sales_agent,EXTRACT(YEAR FROM sp.close_date),EXTRACT(QUARTER FROM sp.close_date) 
ORDER BY Total_sales DESC
LIMIT 10;

/* 6. To find the Top 5 Product by sales
using the sales pipeline and product table to find the top selling products
*/
SELECT 
sp.product,
SUM(sp.close_value) AS Total_sales
FROM sales_pipeline sp
JOIN products p 
ON sp.product = p.product
WHERE sp.deal_stage = "Won"
GROUP BY p.product
ORDER BY Total_sales DESC
LIMIT 5;

/* 7. To get the sales by Account Sector for each quarter
analyzing the performance of sales by different sectors
using the Account table and sales pipeline table
*/
SELECT a.sector,
EXTRACT(YEAR FROM sp.close_date) AS Year,
EXTRACT(Quarter FROM sp.close_date) AS Quarter,
SUM(sp.close_value) AS Total_sales
FROM sales_pipeline sp
JOIN accounts a 
ON sp.account = a.account
WHERE sp.deal_stage = "Won"
GROUP BY  a.sector,EXTRACT(YEAR FROM sp.close_date), EXTRACT(Quarter FROM sp.close_date)
ORDER BY a.sector, Year, Quarter;

-- 8.  To see how Opportunities move through the pipeline stages
SELECT deal_stage,
COUNT(opportunity_id) AS Opportunity_count
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY Opportunity_count DESC;

/* . To Analyze sales per regional_office by joining sale team and sales pipeline
with a group by on regional_office
*/
SELECT st.regional_office,
EXTRACT(YEAR FROM sp.close_date) AS Year,
EXTRACT(Quarter FROM sp.close_date) AS Quarter,
SUM(sp.close_value) AS Total_sales
FROM sales_teams st
JOIN sales_pipeline sp 
ON st.sales_agent = sp.sales_agent
WHERE sp.deal_stage = "Won"
GROUP BY  st.regional_office,EXTRACT(YEAR FROM sp.close_date), EXTRACT(Quarter FROM sp.close_date)
ORDER BY st.regional_office, Year, Quarter;

-- . Total sales closed by Sales Agent
SELECT
sales_agent,
SUM(close_value) AS Total_sales,
COUNT(deal_stage) AS Total_deals_Won
FROM sales_pipeline
WHERE deal_stage = "Won"
GROUP BY sales_agent
ORDER BY 3 DESC;

/* 9. To calculate the number of total opportunities engaged, as well as those won and lost by each manager.
I Join the sales_pipeline table with the sales_team table (since the manager information is in the sales_team table).
Count the total opportunities engaged for each manager.
Count the opportunities that are won (deals with the stage "Closed Won").
Count the opportunities that are lost (deals with the stage "Closed Lost").
*/
SELECT
st.manager,
COUNT(sp.opportunity_id) AS Total_Opportunity,
COUNT(CASE WHEN sp.deal_stage = "Won" THEN 1 END) AS Opportunity_Won,
COUNT(CASE WHEN sp.deal_stage = "Lost" THEN 1 END) AS Opportunity_lost
FROM sales_pipeline sp
JOIN sales_teams st
ON sp.sales_agent = st.sales_agent
GROUP BY st.manager
ORDER BY Total_Opportunity DESC;