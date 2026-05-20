import pandas as pd
import pyodbc
from transformers import pipeline

def fetch_data_from_sql():
    conn_str = (
        "Driver={SQL Server};"
        "Server=ADMIN\\SQLEXPRESS;"
        "Database=CSAdb;"
        "Trusted_Connection=yes;"
    )

    conn = pyodbc.connect(conn_str)


#joining of dbo.customer and dbo.products tables
    query = """
    SELECT 
        cr.ReviewID,
        cr.CustomerID,
        cr.ProductID,
        p.ProductName,        -- Product name from product table
        cr.ReviewDate,
        cr.Rating,
        cr.ReviewText
    FROM dbo.customer_reviews cr
    INNER JOIN dbo.products p
        ON cr.ProductID = p.ProductID
    """

    df = pd.read_sql(query, conn)
    conn.close()
    return df


customer_reviews_df = fetch_data_from_sql()


#distilbert model(fine-tuned specificallt for sentiment analysis)
bert_pipeline = pipeline(
    "sentiment-analysis",
    model="distilbert-base-uncased-finetuned-sst-2-english"
)

def calculate_bert_sentiment(review):
    try:
        result = bert_pipeline(str(review)[:512])[0]
        label = result['label']
        confidence = result['score']

        # Convert to -1 to +1 scale
        if label == "POSITIVE":
            return confidence
        else:
            return -confidence

    except:
        return 0
    
def categorize_bert(score):
    if score > 0.05:
        return "Positive"
    elif score < -0.05:
        return "Negative"
    else:
        return "Neutral"   
    
customer_reviews_df['BERT_SentimentScore'] = (
    customer_reviews_df['ReviewText']
    .apply(calculate_bert_sentiment)
)


def five_bucket_sentiment(score, rating):

    # Strong Positive
    if score >= 0.6 and rating >= 4:
        return "Positive"

    # Mild Positive
    elif score > 0.05:
        if rating >= 4:
            return "Positive"
        elif rating == 3:
            return "Mixed Positive"
        else:
            return "Mixed Negative"

    # Neutral Text
    elif -0.05 <= score <= 0.05:
        if rating >= 4:
            return "Mixed Positive"
        elif rating <= 2:
            return "Mixed Negative"
        else:
            return "Neutral"

    # Mild Negative
    elif score < -0.05:
        if rating <= 2:
            return "Negative"
        elif rating == 3:
            return "Mixed Negative"
        else:
            return "Mixed Positive"

    # Strong Negative
    else:
        return "Negative"


customer_reviews_df['BERT_SentimentScore'] = (
    customer_reviews_df['ReviewText']
    .apply(calculate_bert_sentiment)
)

customer_reviews_df['FiveBucketSentiment'] = (
    customer_reviews_df.apply(
        lambda row: five_bucket_sentiment(
            row['BERT_SentimentScore'],
            row['Rating']
        ),
        axis=1
    )
)

# Rename column before saving
customer_reviews_df.rename(
    columns={'FiveBucketSentiment': 'SentimentBucket'},
    inplace=True
)

print(customer_reviews_df.head())

customer_reviews_df.to_csv(
    'abcd.csv',
    index=False
)

print(customer_reviews_df.head())    