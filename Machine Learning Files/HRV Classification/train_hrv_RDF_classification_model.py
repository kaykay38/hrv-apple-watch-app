#!/usr/bin/env python3
import tensorflow_decision_forests as tfdf

import os
import numpy as np
import pandas as pd
import tensorflow as tf
import math
import matplotlib.pyplot as plt
import sys


train_dataset_dataframe = pd.read_csv("./data/train.csv")
test_dataset_dataframe = pd.read_csv("./data/test.csv")

label = "condition"

classes = train_dataset_dataframe[label].unique().tolist()
print(f"Label classes: {classes}")

train_dataset_dataframe[label] = train_dataset_dataframe[label].map(classes.index)


# Split the dataset into a training and a testing dataset.

def split_dataset(dataset, test_ratio=0.30):
  """Splits a panda dataframe in two."""
  test_indices = np.random.rand(len(dataset)) < test_ratio
  return dataset[~test_indices], dataset[test_indices]


train_ds_pd = train_dataset_dataframe
test_ds_pd = test_dataset_dataframe
# train_ds_pd, test_ds_pd = split_dataset(dataset_dataframe)
print("{} examples in training, {} examples for testing.".format(
    len(train_ds_pd), len(test_ds_pd)))


train_ds = tfdf.keras.pd_dataframe_to_tf_dataset(train_ds_pd, label=label)
test_ds = tfdf.keras.pd_dataframe_to_tf_dataset(test_ds_pd, label=label)


# set_cell_height 300

# Specify the model.
model_1 = tfdf.keras.RandomForestModel()

# Train the model.
model_1.fit(x=train_ds)

model_1.compile(metrics=["accuracy"])

# Test the model
evaluation = model_1.evaluate(test_ds, return_dict=True)
print()

for name, value in evaluation.items():
    print(f"{name}: {value:.4f}")


# Save the model
model_1.save(sys.argv[1] or "./HRVClassificationModel")


# Plot the model
tfdf.model_plotter.plot_model_in_colab(model_1, tree_idx=0, max_depth=3)

model_1.summary()

# The input features
model_1.make_inspector().features()

# The feature importances
model_1.make_inspector().variable_importances()

model_1.make_inspector().evaluation()

model_1.make_inspector().training_logs()


# Plot the model
logs = model_1.make_inspector().training_logs()

plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot([log.num_trees for log in logs], [log.evaluation.accuracy for log in logs])
plt.xlabel("Number of trees")
plt.ylabel("Accuracy (out-of-bag)")

plt.subplot(1, 2, 2)
plt.plot([log.num_trees for log in logs], [log.evaluation.loss for log in logs])
plt.xlabel("Number of trees")
plt.ylabel("Logloss (out-of-bag)")

plt.savefig(f'{sys.argv[1] or "HRVClassificationModel"}/figure_1.png')
