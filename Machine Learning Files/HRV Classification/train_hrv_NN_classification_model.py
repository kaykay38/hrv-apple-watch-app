#!/usr/bin/env python3
import os
from tabnanny import verbose
import numpy as np
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt
import sys
from utils import MyUtils

df_X_train = pd.read_csv("./data/train_X_int.csv")
df_y_train = pd.read_csv("./data/train_y_int.csv")
df_X_test = pd.read_csv("./data/test_X_int.csv")
df_y_test = pd.read_csv("./data/test_y_int.csv")

print("df_X_train.columns:",df_X_train.columns)
print("df_y_train.columns:",df_y_train.columns)
# label = "condition"

# classes = df_y_train[label].unique().tolist()
# print(f"Label classes: {classes}")

# save in numpy arrays
X_train = tf.convert_to_tensor(df_X_train['rmssd','hr','user'])
y_train = tf.convert_to_tensor(df_y_train['condition'])
X_test = tf.convert_to_tensor(df_X_test['rmssd','hr','user'])
y_test = tf.convert_to_tensor(df_y_test['condition'])

# get training set size
n_train = X_train.shape[0]
n_test = X_test.shape[0]

# Set random seed
tf.random.set_seed(42)

# #create the model
# model_12=tf.keras.Sequential([
#     tf.keras.layers.Flatten(input_shape=(28,28)),
#     tf.keras.layers.Dense(4,activation="relu"),
#     tf.keras.layers.Dense(4,activation="relu"),
#     tf.keras.layers.Dense(10,activation="softmax")
# ])#compile the model
# model_12.compile(
#    loss=tf.keras.losses.SparseCategoricalCrossentropy(),
#    optimizer=tf.keras.optimizers.Adam(),
#    metrics="accuracy")#create a learning rate callback
# lr_scheduler = tf.keras.callbacks
#     .LearningRateScheduler(lambda epoch : 1e-3 *10**(epoch/20) )#fit the model
# fit_lr_history =model_12.fit(
#    train_data_norm,
#    train_labels,
#    epochs=40,
#    callbacks=[lr_scheduler],
#    validation_data=(test_data_norm,test_labels))

# 1. Create the model using the Sequential API
model_1 = tf.keras.Sequential(
## After TensorFlow 2.7.0 ##
  tf.keras.layers.Flatten(100, input_shape=(None, 3)), # add 100 dense neurons with input_shape defined (None, 1) = look at 1 sample at a time
  tf.keras.layers.Dense(4, activation="relu"), # add a layer with 4 dense neurons and activation function "relu"
  tf.keras.layers.Dense(4, activation="relu"), # add another layer with 10 neurons
  tf.keras.layers.Dense(10, activation="softmax") # add a layer with 10 neurons and activation function "softmax"
    )

# 2. Compile the model
model_1.compile(loss=tf.keras.losses.CategoricalCrossentropy, # categorical since we are working with 3 clases ('low', 'medium', 'high')
                optimizer=tf.keras.optimizers.SGD(),
                metrics=['accuracy'])

# 3. Fit the model
model_1.fit(X_train, y_train, epochs=100, verbose=0, batch_size=100, validation_data=(X_test,y_test))

# Evaluate the model
evaluation = model_1.evaluate(X_train, y_train)

for name, value in evaluation.items():
    print(f"{name}: {value:.4f}")


# 4. Save the model
model_1.save(sys.argv[1] or "./HRVClassificationModel")


# Plot the model
# tfdf.model_plotter.plot_model_in_colab(model_1, tree_idx=0, max_depth=3)

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