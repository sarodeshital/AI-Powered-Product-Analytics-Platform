# =====================================================
# ISSUE PREDICTION SCRIPT
# =====================================================

import pandas as pd
from transformers import pipeline


def predict_issues(input_csv):

    df = pd.read_csv(input_csv)

    issue_model = pipeline(
        "text-classification",
        model="issue_classifier_model",
        tokenizer="issue_classifier_model"
    )

    reviews = df["ReviewText"].astype(str).tolist()

    results = issue_model(
        reviews,
        truncation=True,
        batch_size=16
    )

    df["IssueType"] = [r["label"] for r in results]
    df["IssueConfidence"] = [round(r["score"], 4) for r in results]
    # issue confidence it the value which say how much accurately the issue classification model works
    return df