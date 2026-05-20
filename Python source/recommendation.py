import pandas as pd
import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

# -------------------------------
# DATABASE CONNECTION
# -------------------------------
SERVER = os.getenv("SQL_SERVER")
DB = os.getenv("SQL_DATABASE")
DRIVER = os.getenv("SQL_DRIVER")

conn_str = f"mssql+pyodbc://@{SERVER}/{DB}?driver={DRIVER}&trusted_connection=yes"
engine = create_engine(conn_str)

# -------------------------------
# LOAD DATA
# -------------------------------
df = pd.read_csv(r"D:\CSA\final_ai_output.csv")

# Ensure numeric columns
df['BERT_SentimentScore'] = pd.to_numeric(df['BERT_SentimentScore'], errors='coerce')
df['Rating'] = pd.to_numeric(df['Rating'], errors='coerce')

# -------------------------------
# BUSINESS RECOMMENDATION MODULE
# -------------------------------

print("Generating business recommendations...")

negative_df = df[df['FiveBucketSentiment'].isin(['Negative', 'Mixed Negative'])]

if not negative_df.empty:

    issue_agg = negative_df.groupby(
        ['ProductID', 'ProductName', 'IssueType']
    ).agg({
        'BERT_SentimentScore': 'mean',
        'ReviewID': 'count'
    }).reset_index()

    issue_agg.columns = [
        'ProductID',
        'ProductName',
        'IssueType',
        'avg_sentiment',
        'negative_review_count'
    ]

    # ✅ Separate Severity Index Column
    issue_agg['Severity_Index'] = (
        issue_agg['negative_review_count'] *
        issue_agg['avg_sentiment'].abs()
    ).round(2)

    issue_agg = issue_agg.sort_values(
        by='Severity_Index',
        ascending=False
    )

    # Clean AI text (without severity inside text)
    def generate_action(issue):
        return (
            f"Improve {issue} "
        )

    issue_agg['AI_Suggested_Action'] = issue_agg['IssueType'].apply(generate_action)

    # Reorder columns cleanly
    issue_agg = issue_agg[
        [
            'ProductID',
            'ProductName',
            'IssueType',
            'negative_review_count',
            'avg_sentiment',
            'Severity_Index',
            'AI_Suggested_Action'
        ]
    ]

    issue_agg.to_sql(
        "ai_business_recommendations",
        engine,
        if_exists="replace",
        index=False
    )

    print("Business recommendations written to SQL successfully.")

else:
    print("No negative issues detected.")
# ----------------------------------------------------
# PRODUCT RECOMMENDATION ENGINE
# ----------------------------------------------------

print("Generating product recommendations...")

neg_counts = negative_df.groupby('ProductID')['ReviewID'] \
    .count().reset_index()

neg_counts.columns = ['ProductID', 'negative_count']

agg_df = df.groupby(['ProductID', 'ProductName']).agg({
    'Rating': 'mean',
    'BERT_SentimentScore': 'mean',
    'ReviewID': 'count'
}).reset_index()

agg_df.columns = [
    'ProductID',
    'ProductName',
    'avg_rating',
    'avg_sentiment',
    'total_reviews'
]

agg_df = agg_df.merge(
    neg_counts,
    on='ProductID',
    how='left'
)

agg_df['negative_count'] = agg_df['negative_count'].fillna(0)

# Avoid division by zero
agg_df['total_reviews'] = agg_df['total_reviews'].replace(0, 1)

agg_df['AI_Product_Score'] = (
    (0.5 * agg_df['avg_rating']) +
    (0.4 * agg_df['avg_sentiment']) -
    (0.1 * (agg_df['negative_count'] / agg_df['total_reviews']))
)

agg_df = agg_df.sort_values(
    by='AI_Product_Score',
    ascending=False
)

agg_df.to_sql(
    "ai_product_recommendations",
    engine,
    if_exists="replace",
    index=False
)

print("Product recommendations written to SQL successfully.")