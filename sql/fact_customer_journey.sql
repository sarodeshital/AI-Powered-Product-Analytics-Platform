SELECT
*
FROM dbo.customer_journey

SELECT COUNT(*) 
FROM dbo.customer_journey

-- Step 1: Use a Common Table Expression (CTE) to identify duplicates
WITH DuplicateRecords AS (
    SELECT 
        JourneyID,
        CustomerID,
        ProductID,
        VisitDate,
        Stage,
        Action,
        Duration,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
            ORDER BY JourneyID
        ) AS row_num
    FROM dbo.customer_journey
)
SELECT *
FROM DuplicateRecords
WHERE row_num > 1
ORDER BY JourneyID;

-- Outer query selects the final cleaned and standardized data
-- This query removes duplicates, standardizes Stage values, 
-- and replaces missing Duration with the average for that date

SELECT 
    JourneyID,         -- Unique identifier for each journey
    CustomerID,        -- Unique identifier for each customer
    ProductID,         -- Unique identifier for each product
    VisitDate,         -- Date of the visit
    Stage,             -- Standardized stage (uppercased)
    Action,            -- Action taken by the customer
    COALESCE(Duration, avg_duration) AS Duration  -- Replace missing durations with the daily average
FROM (
    -- Subquery to process and prepare the data
    SELECT 
        JourneyID,     
        CustomerID,    
        ProductID,     
        VisitDate,     
        UPPER(Stage) AS Stage,   -- Convert Stage values to uppercase for consistency
        Action,      
        Duration,     
        AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,  -- Compute average duration per VisitDate
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Group by these fields
            ORDER BY JourneyID   -- Keep only the first occurrence in case of duplicates
        ) AS row_num
    FROM dbo.customer_journey
) AS subquery
WHERE row_num = 1   -- Keep only the first row per group (remove duplicates)
AND
JourneyID = 23;  


INSERT INTO dbo.customer_journey (JourneyID, CustomerID, ProductID, VisitDate, Stage, Action, Duration) VALUES
(3933,12, 21, '2024-04-01', 'Homepage', 'View', 45),
(3942,17, 21, '2024-04-08', 'ProductPage', 'Click', 60),
(3951,19, 21, '2024-04-15', 'Checkout', 'Purchase', 120),
(3954, 25, 21, '2024-04-25', 'ProductPage', 'Add to Cart', 80),
(3943, 36, 21, '2024-05-05', 'Homepage', 'View', 40);

INSERT INTO dbo.customer_journey (JourneyID,CustomerID, ProductID, VisitDate, Stage, Action, Duration) VALUES
(3934, 1, 22, '2024-01-01', 'Homepage', 'View', 35),
(3950, 2, 22, '2025-01-05', 'ProductPage', 'Click', 55),
(3941, 3, 22, '2024-01-15', 'Checkout', 'Purchase', 110),
(3945, 4, 22, '2025-01-25', 'ProductPage', 'Add to Cart', 75),
(3935, 5, 22, '2024-02-05', 'Homepage', 'View', 30);

INSERT INTO dbo.customer_journey (JourneyID,CustomerID, ProductID, VisitDate, Stage, Action, Duration) VALUES
(3955, 9, 23, '2024-01-05', 'Homepage', 'View', 25),
(3949, 0, 23, '2023-01-10', 'ProductPage', 'Click', 60),
(3940, 1, 23, '2024-01-20', 'Checkout', 'Purchase', 95),
(3952, 2, 23, '2024-02-01', 'ProductPage', 'Add to Cart', 70),
(3956, 3, 23, '2025-02-10', 'Homepage', 'View', 28);

INSERT INTO dbo.customer_journey (JourneyID,CustomerID, ProductID, VisitDate, Stage, Action, Duration) VALUES
(3936, 17, 24, '2025-01-01', 'Homepage', 'View', 40),
(3948, 18, 24, '2024-01-10', 'ProductPage', 'Click', 65),
(3957, 19, 24, '2023-01-20', 'Checkout', 'Purchase', 105),
(3946, 20, 24, '2025-02-01', 'ProductPage', 'Add to Cart', 85),
(3939, 21, 24, '2024-02-10', 'Homepage', 'View', 35);

INSERT INTO dbo.customer_journey (JourneyID,CustomerID, ProductID, VisitDate, Stage, Action, Duration) VALUES
(3938, 33, 25, '2025-01-01', 'Homepage', 'View', 50),
(3953, 34, 25, '2023-01-10', 'ProductPage', 'Click', 70),
(3947, 35, 25, '2024-01-20', 'Checkout', 'Purchase', 130),
(3958, 36, 25, '2023-02-01', 'ProductPage', 'Add to Cart', 90),
(3937, 37, 25, '2024-02-10', 'Homepage', 'View', 45);