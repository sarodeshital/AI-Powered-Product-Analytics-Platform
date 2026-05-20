SELECT
*
FROM dbo.customer_reviews


-- Query to clean whitespace issues in the ReviewText column

SELECT 
    ReviewID,  -- Selects the unique identifier for each review
    CustomerID,  -- Selects the unique identifier for each customer
    ProductID,  -- Selects the unique identifier for each product
    ReviewDate,  -- Selects the date when the review was written
    Rating,  -- Selects the numerical rating given by the customer (e.g., 1 to 5 stars)
    -- Cleans up the ReviewText by replacing double spaces with single spaces to ensure the text is more readable and standardized
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM 
    dbo.customer_reviews;  -- Specifies the source table from which to select the data


INSERT INTO dbo.customer_reviews 
(ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText)
VALUES
(1364, 12, 21, '2024-04-05', 5, 'Excellent badminton racket with strong frame and perfect balance.'),
(1365, 17, 21, '2024-04-12', 4, 'Lightweight and comfortable grip, very good for practice.'),
(1366, 19, 21, '2024-04-18', 5, 'High quality racket, improves smash power.'),
(1367, 25, 21, '2024-05-01', 3, 'Average quality but good for beginners.'),
(1368, 36, 21, '2024-05-10', 4, 'Good value for money and durable material.');

SELECT COUNT(*) 
FROM dbo.customer_reviews
WHERE ReviewText = 'Good  quality,  but  could  be  cheaper.';


--mixed positive
UPDATE dbo.customer_reviews
SET ReviewText = 'Average product, quality is fine but price feels slightly high.'
WHERE ReviewID % 3 = 0
AND ReviewText = 'Good  quality,  but  could  be  cheaper.';

UPDATE dbo.customer_reviews
SET ReviewText = 'Average quality, delivery was slightly delayed.'
WHERE ReviewID % 3 = 1
AND ReviewText = 'Good  quality,  but  could  be  cheaper.';

UPDATE dbo.customer_reviews
SET ReviewText = 'Very durable and performs well for daily use.'
WHERE ReviewID % 3 = 2
AND ReviewText = 'Good  quality,  but  could  be  cheaper.';

UPDATE dbo.customer_reviews
SET ReviewText = 'Average product, works fine but feels slightly overpriced.'
WHERE ReviewID % 4 = 0
AND ReviewText = 'Not  worth  the  money.';


--mixed negative
UPDATE dbo.customer_reviews
SET ReviewText = 'Build quality is okay, however durability could definitely be better.'
WHERE ReviewID % 4 = 1
AND ReviewText = 'Not  worth  the  money.';

UPDATE dbo.customer_reviews
SET ReviewText = 'It performs the basic function, but I expected better finishing and comfort.'
WHERE ReviewID % 4 = 2
AND ReviewText = 'Not  worth  the  money.';

UPDATE dbo.customer_reviews
SET ReviewText = 'Usable for beginners, though the overall quality does not justify the price.'
WHERE ReviewID % 4 = 3
AND ReviewText = 'Not  worth  the  money.';

-- neutral
UPDATE dbo.customer_reviews
SET ReviewText = 'The quality is satisfactory overall.'
WHERE ReviewID % 3 = 1
AND ReviewText = 'The  quality    is  top-notch.';

UPDATE dbo.customer_reviews
SET ReviewText = 'The material feels standard and usable.'
WHERE ReviewID % 3 = 2
AND ReviewText = 'The  quality    is  top-notch.';

UPDATE dbo.customer_reviews
SET ReviewText = 'Packaging was adequate and delivery was timely.'
WHERE ReviewID % 3 = 1
AND ReviewText = 'Shipping  was  fast  and  the  item  was  well-packaged.';

UPDATE dbo.customer_reviews
SET ReviewText = 'The product reached without any damage.'
WHERE ReviewID % 3 = 2
AND ReviewText = 'Shipping  was  fast  and  the  item  was  well-packaged.';

UPDATE dbo.customer_reviews
SET ReviewText = 'The product arrived within the expected timeframe.'
WHERE ReviewID % 3 = 1
AND ReviewText = 'Five  stars    for  the  quick  delivery.';

UPDATE dbo.customer_reviews
SET ReviewText = 'The order was delivered without delay'
WHERE ReviewID % 3 = 2
AND ReviewText = 'Five  stars    for  the  quick  delivery.';


--skipping ropes
INSERT INTO dbo.customer_reviews (ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText) VALUES
(1369, 1, 22, '2024-01-05', 5, 'Excellent quality rope, very durable and smooth rotation.'),
(1371, 2, 22, '2025-01-12', 4, 'Good for daily workouts, though handles feel slightly light.'),
(1375, 3, 22, '2024-01-20', 3, 'Works as expected for regular skipping sessions.'),
(1380, 4, 22, '2025-02-02', 2, 'Usable rope but tangles occasionally.'),
(1384, 5, 22, '2024-02-10', 1, 'Poor build quality, broke within a week.'),
(1391,6, 22, '2023-02-18', 5, 'Perfect for cardio and very easy to adjust.'),
(1397, 7, 22, '2024-03-01', 4, 'Lightweight and convenient, but grip could improve.'),
(1392,8, 22, '2025-03-10', 3, 'Average product, nothing special.');

--tennis balls
INSERT INTO dbo.customer_reviews (ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText) VALUES
(1370, 9, 23, '2024-01-07', 5, 'Great bounce and long-lasting pressure.'),
(1377, 1, 23, '2024-01-25', 3, 'Decent quality for casual play.'),
(1383, 2, 23, '2024-02-05', 2, 'Initially good, but durability is limited.'),
(1385, 3, 23, '2025-02-15', 1, 'Lost bounce after one session.'),
(1390,4, 23, '2024-02-25', 5, 'Excellent control and consistent bounce.'),
(1396, 5, 23, '2023-03-05', 4, 'Good quality balls, slightly overpriced.'),
(1393, 6, 23, '2024-03-15', 3, 'Average performance overall.');

INSERT INTO dbo.customer_reviews (ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText) VALUES
(1373, 12, 10, '2023-01-15', 4, 'Good for club matches, but lose pressure slightly fast.');


--swimmingkickboard
INSERT INTO dbo.customer_reviews (ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText) VALUES
(1372, 17, 24, '2025-01-08', 5, 'Very sturdy and provides excellent flotation support.'),
(1376, 18, 24, '2024-01-18', 4, 'Good grip, but slightly smaller than expected.'),
(1379, 19, 24, '2023-01-28', 3, 'Basic kickboard, works fine for beginners.'),
(1382, 20, 24, '2025-02-08', 2, 'Material feels average and could be stronger.'),
(1386, 21, 24, '2024-02-18', 1, 'Very weak material and cracked quickly.'),
(1389, 22, 24, '2023-03-01', 5, 'Perfect for swim training sessions.'),
(1399, 23, 24, '2024-03-10', 4, 'Comfortable to hold, decent quality.'),
(1395, 24, 24, '2025-03-20', 3, 'Standard product with average durability.');

--skating helmets
INSERT INTO dbo.customer_reviews (ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText) VALUES
(1374, 33, 25, '2025-01-06', 5, 'Excellent protection and very comfortable.'),
(1378, 34, 25, '2023-01-16', 4, 'Provides good safety but ventilation is average.'),
(1381, 35, 25, '2024-01-26', 3, 'Standard helmet for basic use.'),
(1387, 36, 25, '2023-02-06', 2, 'Fits okay, but strap quality feels weak.'),
(1398, 37, 25, '2024-02-16', 1, 'Poor build quality and unsafe feel.'),
(1388, 38, 25, '2025-03-01', 5, 'Very secure and lightweight design.'),
(1394, 39, 25, '2024-03-12', 4, 'Good comfort, slightly tight fit.'),
(1400,40, 25, '2023-03-22', 3, 'Average safety features.');


UPDATE dbo.customer_reviews
SET CustomerID = 10
WHERE ReviewID = 1373
  AND CustomerID = 0;


DELETE FROM dbo.customer_reviews
WHERE ReviewID = 1373
  AND CustomerID = 12
  AND ProductID = 23
  AND ReviewDate = '2023-01-15'
  AND Rating = 4;



-- Cleaning + Normalization + Formatting + Remove Punctuation

SELECT 
    ReviewID,
    CustomerID,
    ProductID,
    
    -- Format date
    FORMAT(ReviewDate, 'yyyy-MM-dd') AS ReviewDate,
    
    Rating,

    LOWER(
        LTRIM(RTRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            TRANSLATE(
                                ReviewText,
                                '.,!?;:"''()[]{}@#$%^&*_+=<>/\|~`-',
                                '                                '  -- same length spaces
                            ),
                        CHAR(13), ' '),
                    CHAR(10), ' '),
                CHAR(9), ' '),
            '  ', ' ')
        ))
    ) AS ReviewText

FROM dbo.customer_reviews

WHERE ReviewText IS NOT NULL
AND LTRIM(RTRIM(ReviewText)) <> '';