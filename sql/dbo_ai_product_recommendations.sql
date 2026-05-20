SELECT *
FROM dbo.ai_product_recommendations;


--A) View Product Ranking (Best to Worst)
SELECT 
    ProductID,
    ProductName,
    ROUND(avg_rating, 2) AS avg_rating,
    ROUND(avg_sentiment, 2) AS avg_sentiment,
    total_reviews,
    negative_count,
    ROUND(AI_Product_Score, 3) AS AI_Product_Score
FROM dbo.ai_product_recommendations
ORDER BY AI_Product_Score DESC;

--B) Top 5 Best Products
SELECT TOP 5
    ProductID,
    ProductName,
    AI_Product_Score
FROM dbo.ai_product_recommendations
ORDER BY AI_Product_Score DESC;

--C) Bottom 5 Products (At Risk)
SELECT TOP 5
    ProductID,
    ProductName,
    AI_Product_Score
FROM dbo.ai_product_recommendations
ORDER BY AI_Product_Score ASC;

--D) Products with High Negative Ratio
SELECT 
    ProductID,
    ProductName,
    negative_count,
    total_reviews,
    CAST(negative_count AS FLOAT) / total_reviews AS negative_ratio
FROM dbo.ai_product_recommendations
ORDER BY negative_ratio DESC;

