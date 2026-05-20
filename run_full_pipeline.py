# =====================================================
# COMPLETE AI PIPELINE
# =====================================================

import pandas as pd
from transformers import pipeline


# Business Logic Function
def apply_business_logic(df):

    if "SentimentBucket" not in df.columns:
        raise ValueError("Column 'SentimentBucket' not found.")

    df["BusinessOutput"] = None

    # Negative → keep IssueTypes
    mask_negative = df["SentimentBucket"].isin(["Negative", "Mixed Negative"])
    df.loc[mask_negative, "BusinessOutput"] = df.loc[mask_negative, "IssueType"]

    # Mixed Positive → Improvement suggestions
    df.loc[df["SentimentBucket"] == "Mixed Positive", "BusinessOutput"] = "Improvement suggestions"

    # Positive → Customer satisfied
    df.loc[df["SentimentBucket"] == "Positive", "BusinessOutput"] = "Customer satisfied."

    # Remove IssueType if not negative
    df.loc[~mask_negative, "IssueType"] = None

    return df


# Run Full Pipeline
def run_pipeline(input_path, output_path):

    print("Loading input file...")
    df = pd.read_csv(input_path)

    if "ReviewText" not in df.columns:
        raise ValueError("Input CSV must contain 'ReviewText' column.")

    df["ReviewText"] = df["ReviewText"].fillna("").astype(str)

    print("Loading trained issue classification model...")
    issue_model = pipeline(
        "text-classification",
        model="issue_classifier_model",
        tokenizer="issue_classifier_model"
    )

    print("Running issue classification...")
    reviews = df["ReviewText"].tolist()

    results = issue_model(
        reviews,
        truncation=True,
        batch_size=16
    )

    df["IssueType"] = [r["label"] for r in results]
    df["IssueConfidence"] = [round(r["score"], 4) for r in results]

    print("Applying business logic...")
    df = apply_business_logic(df)

    print("Saving final AI output...")
    df.to_csv(output_path, index=False)

    print("Final AI output generated successfully!")
    print("Saved at:", output_path)


# =====================================
# MAIN EXECUTION
# =====================================
if __name__ == "__main__":

    input_file = "abcd.csv"
    output_file = "final_ai_output.csv"

    run_pipeline(input_file, output_file)