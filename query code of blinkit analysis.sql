UPDATE blinkit_data
SET "Item_Fat_Content" =
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content ='reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT * FROM blinkit_data
SELECT COUNT(*) AS "No.Of Items" FROM blinkit_data

SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data
SELECT AVG(Total_Sales) FROM dbo.BlinkIT_data
SELECT AVG(Total_Sales) FROM blinkIT_data

SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)),'M') AS Total_Sales_Millions
FROM blinkit_data
WHERE Item_Fat_Content = 'Low Fat' 


SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS "Average" FROM blinkit_data
WHERE "Item_Fat_Content" = 'Low Fat'

SELECT CAST(AVG("Rating") AS DECIMAL(10,2)) AS "Avg_Rating" FROM blinkit_data

SELECT column_name
From information_schema.columns
where table_name='blinkit_data'

-- granular req
-- TOTAL SALES BY FAT CONTENT
SELECT "Item_Fat_Content",
		CONCAT(CAST(SUM("Total_Sales")/1000 AS DECIMAL(10,2)),'K') AS "Total_Sales_Thousands",
		CAST(AVG("Total_Sales") AS DECIMAL(10,1)) AS "Average_Sales",
		COUNT (*) AS NO_0f_Items,
		CAST(AVG("Rating") AS DECIMAL(10,2)) AS "Average_Rating"
FROM blinkit_data
--any WHERE CONDITION 
GROUP BY "Item_Fat_Content"
ORDER BY "Total_Sales_Thousands" DESC


-- TOTAL SALES BY ITEM TYPE
SELECT "Item_Type",
		CAST(SUM("Total_Sales") AS DECIMAL(10,2)) AS "Total_Sales",
		CAST(AVG("Total_Sales") AS DECIMAL(10,1)) AS "Average_Sales",
		COUNT (*) AS NO_0f_Items,
		CAST(AVG("Rating") AS DECIMAL(10,2)) AS "Average_Rating"		
FROM blinkit_data
GROUP BY "Item_Type"
ORDER BY "Total_Sales" DESC
 -- only show top five then do SELECT TOP 5 Item_Type

--TOTAL fat content and outlet location type FOR TOTAL SALES
SELECT "Outlet_Location_Type",
	COALESCE("Low Fat",0) AS Low_Fat,
	COALESCE("Regular",0) AS Regular
FROM
(
		SELECT "Outlet_Location_Type","Item_Fat_Content",
			CAST(SUM("Total_Sales") AS DECIMAL(10,2)) AS "Total_Sales"  --want to see for avg chnage sum to avg
		FROM blinkit_data
		GROUP BY "Outlet_Location_Type","Item_Fat_Content"
) AS SourceTable
PIVOT(
	SUM("Total_Sales")
	FOR "Item_Fat_Content" IN ([Low Fat], [Regular])	
)AS PivotTable
ORDER BY "Outlet_Location_Type";


--total sales by outlet establishment year
SELECT "Outlet_Establishment_Year",
	CAST(SUM("Total_Sales") AS DECIMAL(10,2)) AS "Total_Sales",
	CAST(AVG("Total_Sales") AS DECIMAL(10,1)) AS "Average_Sales",
	COUNT (*) AS NO_0f_Items,
	CAST(AVG("Rating") AS DECIMAL(10,2)) AS "Average_Rating"		
FROM blinkit_data
GROUP BY "Outlet_Establishment_Year" 
ORDER BY Total_Sales  DESC


--Percentage of sales by outlet size
SELECT "Outlet_Size",
	CAST(SUM("Total_Sales") AS DECIMAL(10,2)) AS "Total_Sales",
	CAST((SUM("Total_Sales")*100.0/SUM(SUM("Total_Sales")) OVER()) AS DECIMAL(10,2)) AS "Sales_Percentage"
FROM blinkit_data
GROUP BY "Outlet_Size"
ORDER BY "Total_Sales" DESC

--Sales by outlet location type
SELECT "Outlet_Location_Type",
	CAST(SUM("Total_Sales") AS DECIMAL(10,2)) AS "Total_Sales",
	CAST(AVG("Total_Sales") AS DECIMAL(10,1)) AS "Average_Sales",
	CAST((SUM("Total_Sales")*100.0/SUM(SUM("Total_Sales")) OVER()) AS DECIMAL(10,2)) AS "Sales_Percentage",
	COUNT (*) AS NO_0f_Items,
	CAST(AVG("Rating") AS DECIMAL(10,2)) AS "Average_Rating"
FROM blinkit_data
GROUP BY "Outlet_Location_Type" 
ORDER BY "Total_Sales"  DESC ;

--Sales by outlet type
SELECT "Outlet_Type",
	CAST(SUM("Total_Sales") AS DECIMAL(10,2)) AS "Total_Sales",
	CAST(AVG("Total_Sales") AS DECIMAL(10,1)) AS "Average_Sales",
	CAST((SUM("Total_Sales")*100.0/SUM(SUM("Total_Sales")) OVER()) AS DECIMAL(10,2)) AS "Sales_Percentage",
	COUNT (*) AS NO_0f_Items,
	CAST(AVG("Rating") AS DECIMAL(10,2)) AS "Average_Rating"
FROM blinkit_data
GROUP BY "Outlet_Type" 
ORDER BY "Total_Sales"  DESC

