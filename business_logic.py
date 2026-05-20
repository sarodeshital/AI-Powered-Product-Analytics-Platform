def apply_business_logic(df):

    # Ensure required columns exist
    required_columns = ["SentimentBucket", "IssueType"]
    for col in required_columns:
        if col not in df.columns:
            raise ValueError(f"Missing required column: {col}")

    #defining business logic 
    def business_logic(row):

        sentiment = row["SentimentBucket"]
        issue = row["IssueType"]

        if sentiment in ["Negative", "Mixed Negative"]:
            return issue

        elif sentiment == "Mixed Positive":
            return "Improvement suggestions"

        elif sentiment == "Positive":
            return "Customer satisfied."

        else:
            return None

    df["BusinessOutput"] = df.apply(business_logic, axis=1)


    # Remove IssueType if sentiment is not negative
    df.loc[
        ~df["SentimentBucket"].isin(["Negative", "Mixed Negative"]),
        "IssueType"
    ] = None

    return df