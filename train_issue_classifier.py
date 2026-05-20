# =====================================================
# TRAIN ISSUE CLASSIFIER - DistilBERT
# =====================================================

import pandas as pd
import numpy as np
from datasets import Dataset
from transformers import (
    DistilBertTokenizerFast,
    DistilBertForSequenceClassification,
    Trainer,
    TrainingArguments
)
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import (
    classification_report,
    accuracy_score,
    precision_recall_fscore_support
)



# LOAD DATA
print("Loading training and testing datasets...")

train_df = pd.read_csv(r"D:\CSA\issue_train.csv")
test_df = pd.read_csv(r"D:\CSA\issue_test.csv")

print("Train size:", len(train_df))
print("Test size:", len(test_df))



#ENCODE LABELS
# Assigning text labels(according tothe category of issue) to issue types
label_encoder = LabelEncoder()

train_df["label"] = label_encoder.fit_transform(train_df["label"])
test_df["label"] = label_encoder.transform(test_df["label"])

num_labels = len(label_encoder.classes_)

id2label = {i: label for i, label in enumerate(label_encoder.classes_)}
label2id = {label: i for i, label in enumerate(label_encoder.classes_)}

print("Label Mapping:", id2label)


#  Convert to HuggingFace Dataset
train_dataset = Dataset.from_pandas(train_df)
test_dataset = Dataset.from_pandas(test_df)


# TOKENIZATION
#tokenizationn of reviews,to analyse the category of issue
print("Loading tokenizer...")

tokenizer = DistilBertTokenizerFast.from_pretrained(
    "distilbert-base-uncased"
)

def tokenize(batch):
    return tokenizer(
        batch["text"],
        padding="max_length",
        truncation=True,
        max_length=128
    )


train_dataset = train_dataset.map(tokenize, batched=True)
test_dataset = test_dataset.map(tokenize, batched=True)

#set format of train dataset for issue classification training
train_dataset.set_format(
    "torch",
    columns=["input_ids", "attention_mask", "label"]
)

#set format of test dataset for issue classification training
test_dataset.set_format(
    "torch",
    columns=["input_ids", "attention_mask", "label"]
)


# LOAD MODEL
print("Loading DistilBERT model...")

model = DistilBertForSequenceClassification.from_pretrained(
    "distilbert-base-uncased",
    num_labels=num_labels,
    id2label=id2label,
    label2id=label2id
)


#TRAINING CONFIGURATION
training_args = TrainingArguments(
    output_dir="./results",
    learning_rate=2e-5,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=16,
    num_train_epochs=3,
    weight_decay=0.01,
    save_strategy="no"
)


#  METRICS FUNCTION
def compute_metrics(eval_pred):
    logits, labels = eval_pred
    predictions = np.argmax(logits, axis=1)

    accuracy = accuracy_score(labels, predictions)
    precision, recall, f1, _ = precision_recall_fscore_support(
        labels,
        predictions,
        average="weighted"
    )

    return {
        "accuracy": accuracy,
        "precision": precision,
        "recall": recall,
        "f1": f1
    }


#  TRAINER
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=test_dataset,
    compute_metrics=compute_metrics
)


#  TRAIN MODEL
print("Training model...")
trainer.train()


# EVALUATE MODEL
print("Evaluating model...")

predictions = trainer.predict(test_dataset)

y_pred = np.argmax(predictions.predictions, axis=1)
y_true = predictions.label_ids

accuracy = accuracy_score(y_true, y_pred)
precision, recall, f1, _ = precision_recall_fscore_support(
    y_true,
    y_pred,
    average="weighted"
)

print("\n================ MODEL PERFORMANCE ================")
print(f"Accuracy  : {accuracy:.2f}")
print(f"Precision : {precision:.2f}")
print(f"Recall    : {recall:.2f}")
print(f"F1 Score  : {f1:.2f}")

print("\n================ CLASSIFICATION REPORT ================")
print(classification_report(
    y_true,
    y_pred,
    target_names=label_encoder.classes_
))


# SAVE MODEL & METRICS
print("Saving model and evaluation report...")

model.save_pretrained("issue_classifier_model")
tokenizer.save_pretrained("issue_classifier_model")

# Save evaluation report
with open("model_evaluation_results.txt", "w") as f:
    f.write("=========== MODEL EVALUATION RESULTS ===========\n\n")
    f.write(f"Accuracy  : {accuracy:.2f}\n")
    f.write(f"Precision : {precision:.2f}\n")
    f.write(f"Recall    : {recall:.2f}\n")
    f.write(f"F1 Score  : {f1:.2f}\n\n")

    f.write("Classification Report:\n\n")
    f.write(classification_report(
        y_true,
        y_pred,
        target_names=label_encoder.classes_
    ))

print("Model and evaluation report saved successfully!")


# Save predictions for external graph scripts
results_df = pd.DataFrame({
    "true_label": y_true,
    "predicted_label": y_pred
})

#save final output of issue model training ina csv file
results_df.to_csv(r"D:\CSA\evaluation_predictions.csv", index=False)
print("Evaluation predictions saved as evaluation_predictions.csv")