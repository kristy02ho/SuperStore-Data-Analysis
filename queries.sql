# Change Order Date into date type
SELECT `Order Date`, STR_TO_DATE(`Order Date`, '%m/%d/%Y')
FROM superstore;

UPDATE superstore
SET `Order Date`= STR_TO_DATE(`Order Date`, '%m/%d/%Y');

ALTER TABLE superstore
MODIFY COLUMN `Order Date` DATE;

# Change Ship Date into date type
SELECT `Ship Date`, STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
FROM superstore;

UPDATE superstore
SET `Ship Date`= STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

ALTER TABLE superstore
MODIFY COLUMN `Ship Date` DATE;

# KPI's
SELECT
	COUNT(*) AS `Total Orders`, 
	SUM(Sales) AS `Total Sales`, 
    SUM(Profit) AS `Total Profit`,
    AVG(Sales) AS `Avg Order Value`,
    ROUND(AVG(Quantity)) AS `Avg Product Quantity`,
	(
	SELECT COUNT(`Returns`) 
    FROM superstore
	WHERE `Returns` = "Yes"
    ) / COUNT(*) * 100 AS `Avg Return Rate (%)`
FROM superstore;

#1.	Sales Trend Analysis: How do sales and profit value evolve over time?
SELECT 
	YEAR(`Order Date`) AS `Year`,
	MONTH(`Order Date`) AS `Month`, 
    SUM(Sales) AS `Total Sales`, 
    SUM(Profit) AS `Total Profit`,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS `Profit Margin (%)`
FROM superstore
GROUP BY `Year`, `Month`;

# Regional Comparisons: How do sales and profit vary across different regions and states?
SELECT 
	Region,
    SUM(Sales) AS `Total Sales`, 
    SUM(Profit) AS `Total Profit`
FROM superstore
GROUP BY Region
ORDER BY `Total Sales` DESC;

SELECT 
	Region,
	State, 
    SUM(Sales) AS `Total Sales`, 
    SUM(Profit) AS `Total Profit`
FROM superstore
GROUP BY Region, State
ORDER BY `Total Sales` DESC;

# 3. Best-Selling and Most Profitable Categories: Which categories lead in terms of sales volume and profitability?
# Best Selling
SELECT Category, SUM(Sales) AS `Total Sales`
FROM superstore
GROUP BY Category
ORDER BY SUM(Sales) DESC;

# Most profitable
SELECT Category, SUM(Profit) AS `Total Profit`
FROM superstore
GROUP BY Category
ORDER BY SUM(Profit) DESC;

# 4. Top 10 Sub-Categories by Sales and Profit: What are the most successful sub-categories based on sales and profit?
# Best Selling
SELECT `Sub-Category`, SUM(Sales) AS `Total Sales`
FROM superstore
GROUP BY `Sub-Category`
ORDER BY SUM(Sales) DESC
LIMIT 10;

# Most profitable
SELECT `Sub-Category`, SUM(Profit) AS `Total Profit`
FROM superstore
GROUP BY `Sub-Category`
ORDER BY SUM(Profit) DESC
LIMIT 10;

#5.	Top 10 Products by Sales and Profit: Which products generate the highest sales and profit?
# Best Selling
SELECT `Product Name`, SUM(Sales) AS "Total Sales"
FROM superstore
GROUP BY `Product Name`
ORDER BY SUM(SALES) DESC
LIMIT 10;

# Most profitable
SELECT `Product Name`, SUM(Profit) AS "Total Profit"
FROM superstore
GROUP BY `Product Name`
ORDER BY SUM(Profit) DESC
LIMIT 10;

#6.	Return Rate by Category: What are the return rates across different product categories?
WITH Return_count AS (
	SELECT 
		`Returns`, 
		Category, 
        COUNT(`Returns`) AS `Return Total`
	FROM superstore
    WHERE `Returns` = "Yes"
	GROUP BY 
		`Returns`, 
        Category
)
SELECT 
    Category,
    `Return Total`/(SELECT COUNT(*) FROM superstore) * 100 AS `Return Rate (%)`
FROM Return_count
ORDER BY `Return Rate (%)` DESC;

# 7. Customer Segments with Highest Sales: Which customer are driving the most sales?
SELECT Segment, SUM(Sales) AS `Total Sales`
FROM superstore
GROUP BY Segment
ORDER BY SUM(Sales) DESC;

#8.	Impact of Quantity Ordered on Profit: How do order quantities influence profit?
SELECT 
	Quantity, 
    SUM(Profit) AS `Total Profit`
FROM superstore
GROUP BY Quantity
ORDER BY SUM(Profit) DESC;

#9. Relationship Between Shipping Times and Returns: Does longer shipping time lead to more product returns?
WITH Return_count AS (
    SELECT 
        DATEDIFF(`Ship Date`, `Order Date`) AS `Shipping Time (days)`, 
        COUNT(*) AS `Return Count`
    FROM superstore
    WHERE `Returns` = "Yes"
    GROUP BY `Shipping Time (days)`
)
SELECT 
    `Shipping Time (days)`, 
    `Return Count` / (SELECT COUNT(*) FROM superstore) * 100 AS `Return Rate (%)`
FROM Return_count
ORDER BY `Shipping Time (days)`;