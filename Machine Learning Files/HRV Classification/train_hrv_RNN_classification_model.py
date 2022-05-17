#!/usr/bin/env python3
import os
from tabnanny import verbose
import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.utils import to_categorical
import math
import matplotlib.pyplot as plt
import sys
from utils import MyUtils

df_X_train = pd.read_csv("./data/train_x.csv")
df_y_train = pd.read_csv("./data/train_y.csv")
df_X_test = pd.read_csv("./data/test_x.csv")
df_y_test = pd.read_csv("./data/test_y.csv")

label = "condition"

classes = df_y_train[label].unique().tolist()
print(f"Label classes: {classes}")

# save in numpy arrays
X_train_raw = df_X_train.to_numpy()
y_train_raw = df_y_train.to_numpy()
X_test_raw = df_X_test.to_numpy()
y_test_raw = df_y_test.to_numpy()

# get training set size
n_train = X_train_raw.shape[0]
n_test = X_test_raw.shape[0]

X_train = X_test_raw
X_test = X_test_raw

y_train = to_categorical(y_train_raw)
y_test = to_categorical(y_test_raw)


# Set random seed
tf.random.set_seed(42)

# 1. Create the model using the Sequential API
model = keras.Sequential()
model.add(layers.Embedding(input_dim=X_train.shape[1], input_length=X_train.shape[1]))

# The output of GRU will be a 3D tensor of shape (batch_size, timesteps, 256)
model.add(layers.GRU(256, return_sequences=True))

# The output of SimpleRNN will be a 2D tensor of shape (batch_size, 128)
model.add(layers.SimpleRNN(128))

model.add(layers.Dense(10))


# 2. Compile the model
model.compile(loss=keras.losses.CategoricalCrossentropy, # categorical since we are working with 3 clases ('low', 'medium', 'high')
                optimizer=keras.optimizers.SGD(),
                metrics=['accuracy'])

# 3. Fit the model
model.fit(X_train, y_train, epochs=100, verbose=0, batch_size=100)

# Evaluate the model
evaluation = model.evaluate(X_train, y_train)

for name, value in evaluation.items():
    print(f"{name}: {value:.4f}")


# 4. Save the model
model.save(sys.argv[1] or "./HRVClassificationModel")


# Plot the model
# tfdf.model_plotter.plot_model_in_colab(model, tree_idx=0, max_depth=3)

model.summary()

# The input features
model.make_inspector().features()

# The feature importances
model.make_inspector().variable_importances()

model.make_inspector().evaluation()

model.make_inspector().training_logs()


# Plot the model
logs = model.make_inspector().training_logs()

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