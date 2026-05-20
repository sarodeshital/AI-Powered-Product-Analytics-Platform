SELECT
*
FROM dbo.engagement_data


-- Query to clean and normalize the engagement_data table

SELECT 
    EngagementID,  -- Selects the unique identifier for each engagement record
    ContentID,  -- Selects the unique identifier for each piece of content
	CampaignID,  -- Selects the unique identifier for each marketing campaign
    ProductID,  -- Selects the unique identifier for each product
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,  -- Replaces "Socialmedia" with "Social Media" and then converts all ContentType values to uppercase
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,  -- Extracts the Views part from the ViewsClicksCombined column by taking the substring before the '-' character
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,  -- Extracts the Clicks part from the ViewsClicksCombined column by taking the substring after the '-' character
    Likes,  -- Selects the number of likes the content received
    -- Converts the EngagementDate to the dd.mm.yyyy format
    FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') AS EngagementDate  -- Converts and formats the date as dd.mm.yyyy
FROM 
    dbo.engagement_data  -- Specifies the source table from which to select the data
WHERE 
    ContentType != 'Newsletter';  -- Filters out rows where ContentType is 'Newsletter' as these are not relevant for our analysis


INSERT INTO dbo.engagement_data 
(EngagementID, ContentID, ContentType, Likes, EngagementDate, CampaignID, ProductID, ViewsClicksCombined)
VALUES
(4624, 51, 'Socialmedia', 320, '2024-04-01', 5, 21, '2500-420'),  --pid 21
(4625, 52, 'Blog', 150, '2024-04-05', 6, 21, '1800-310'),
(4626, 53, 'Video', 420, '2024-04-10', 7, 21, '3500-610'),

(4627, 54, 'Socialmedia', 210, '2024-01-01', 8, 22, '2000-350'),    --pid 22
(4628, 55, 'Blog', 90, '2024-01-10', 9, 22, '1200-180'),
(4629, 56, 'Video', 300, '2024-01-15', 10, 22, '2800-520'),

(4630, 57, 'Socialmedia', 275, '2024-01-05', 11, 23, '2300-390'),   --pid 23
(4631, 58, 'Blog', 120, '2024-01-15', 12, 23, '1600-240'),
(4632, 59, 'Video', 360, '2024-01-20', 13, 23, '3100-580'),

(4633, 60, 'Socialmedia', 190, '2024-01-08', 14, 24, '2100-340'),   --pid 24
(4634, 61, 'Blog', 85, '2024-01-18', 15, 24, '1300-190'),
(4635, 62, 'Video', 410, '2024-01-28', 16, 24, '3300-600'),

(4636, 63, 'Socialmedia', 340, '2024-01-06', 17, 25, '2700-480'),   --pid 25
(4637, 64, 'Blog', 110, '2024-01-16', 18, 25, '1500-260'),
(4638, 65, 'Video', 390, '2024-01-26', 19, 25, '3200-590');

SELECT *
FROM dbo.engagement_data
WHERE EngagementID >= 4624
ORDER BY EngagementID;