# TRAIN TEST SPLIT SCRIPT
#_____________________________________________________________


import pandas as pd
from sklearn.model_selection import train_test_split

print("Loading dataset...")


# Load dataset
file_path = r"D:\CSA\issue_classification_dataset_1200.csv"
df = pd.read_csv(file_path)

print("\nTotal Dataset Size:", len(df))


# REMOVE duplicate TEXT entries
df = df.drop_duplicates(subset=["text"])
print("Dataset size after removing duplicate texts:", len(df))


# Check for Duplicate Rows
duplicates = df.duplicated().sum()
print("\nDuplicate rows in dataset:", duplicates)


# Show Original Class Distribution
print("\nOriginal Class Distribution:")
print(df["label"].value_counts())


# Perform Stratified Train-Test Split (80-20)
train_df, test_df = train_test_split(
    df,
    test_size=0.2,
    stratify=df["label"],
    random_state=42
)

print("\nTrain Size:", len(train_df))
print("Test Size:", len(test_df))


# Check Train-Test Overlap (VERY IMPORTANT)
overlap = set(train_df["text"]).intersection(set(test_df["text"]))
print("\nNumber of overlapping texts between train and test:", len(overlap))


#Show Train Distribution
print("\nTrain Class Distribution:")
print(train_df["label"].value_counts())


# Show Test Distribution
print("\nTest Class Distribution:")
print(test_df["label"].value_counts())


#Save Files
train_path = r"D:\CSA\issue_train.csv"
test_path = r"D:\CSA\issue_test.csv"

train_df.to_csv(train_path, index=False)
test_df.to_csv(test_path, index=False)

print("\nTrain and Test files saved successfully!")
print("Train File Path:", train_path)
print("Test File Path:", test_path)


# Save Split Summary to Text File
log_path = r"D:\CSA\traintestsplit_summary.txt"


with open(log_path, "w") as f:
    f.write("=========== TRAIN TEST SPLIT SUMMARY ===========\n\n")
    f.write(f"Total Dataset Size: {len(df)}\n\n")
    f.write(f"Duplicate Rows: {duplicates}\n\n")
    f.write(f"Overlap Count: {len(overlap)}\n\n")

    f.write("Original Class Distribution:\n")
    f.write(str(df["label"].value_counts()))
    f.write("\n\n")

    f.write(f"Train Size: {len(train_df)}\n")
    f.write("Train Class Distribution:\n")
    f.write(str(train_df["label"].value_counts()))
    f.write("\n\n")

    f.write(f"Test Size: {len(test_df)}\n")
    f.write("Test Class Distribution:\n")
    f.write(str(test_df["label"].value_counts()))
    f.write("\n")


print("Split summary saved as traintestsplit_summary.txt")