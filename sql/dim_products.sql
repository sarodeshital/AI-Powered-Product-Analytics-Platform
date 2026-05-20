SELECT
*
FROM dbo.products



-- SQL Query to categorize products based on their price

SELECT 
    ProductID,  -- Selects the unique identifier for each product
    ProductName,  -- Selects the name of each product
    Price,  -- Selects the price of each product
	-- Category, -- Selects the product category for each product

    CASE -- Categorizes the products into price categories: Low, Medium, or High
        WHEN Price < 50 THEN 'Low'  -- If the price is less than 50, categorize as 'Low'
        WHEN Price BETWEEN 50 AND 200 THEN 'Medium'  -- If the price is between 50 and 200 (inclusive), categorize as 'Medium'
        ELSE 'High'  -- If the price is greater than 200, categorize as 'High'
    END AS PriceCategory  -- Names the new column as PriceCategory

FROM 
    dbo.products;  -- Specifies the source table from which to select the data

INSERT INTO dbo.products (ProductID, ProductName, Category, Price)
VALUES (21, 'Badminton Racket', 'Sports', 95.50),
(22, 'Skipping Rope (Adjustable)', 'Sports', 12.00),
(23, 'Tennis Balls (Pack of 3)', 'Sports', 18.00),
(24, 'Swimming Kickboard', 'Sports', 22.00),
(25, 'Skating Helmet', 'Sports', 55.00);


SELECT ProductID, COUNT(*) AS DuplicateCount
FROM dbo.products
GROUP BY ProductID
HAVING COUNT(*) > 1;



ALTER TABLE dbo.products
ADD CONSTRAINT PK_products PRIMARY KEY (ProductID);