SELECT *
FROM dbo.ai_business_recommendations;



--A) View All Business Recommendations (Sorted by Severity)
SELECT 
    ProductID,
    ProductName,
    IssueType,
    negative_review_count,
    ROUND(avg_sentiment, 2) AS avg_sentiment,
    ROUND(Severity_Index, 2) AS Severity_Index,
    AI_Suggested_Action
FROM dbo.ai_business_recommendations
ORDER BY Severity_Index DESC;

--B) Top 5 Most Critical Issues Across All Products
SELECT TOP 5
    IssueType,
    SUM(negative_review_count) AS total_negative_reviews,
    ROUND(SUM(Severity_Index), 2) AS total_severity_index,
    ROUND(AVG(Severity_Index), 2) AS avg_severity_per_product
FROM dbo.ai_business_recommendations
GROUP BY IssueType
ORDER BY total_severity_index DESC;

--C) Most Problematic Product
SELECT TOP 1
    ProductID,
    ProductName,
    SUM(negative_review_count) AS total_negative_reviews,
    ROUND(SUM(Severity_Index), 2) AS total_severity_index
FROM dbo.ai_business_recommendations
GROUP BY ProductID, ProductName
ORDER BY total_severity_index DESC;

--D) Count of Issues Per Product
SELECT 
    ProductName,
    COUNT(DISTINCT IssueType) AS total_issue_types,
    ROUND(SUM(Severity_Index), 2) AS total_severity_index
FROM dbo.ai_business_recommendations
GROUP BY ProductName
ORDER BY total_severity_index DESC;

--Risk Level Column
SELECT 
    ProductID,
    ProductName,
    IssueType,
    Severity_Index,
    CASE 
        WHEN Severity_Index >= 7.50 THEN 'High Risk'
        WHEN Severity_Index >= 4.50 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Level
FROM dbo.ai_business_recommendations
ORDER BY Severity_Index DESC;