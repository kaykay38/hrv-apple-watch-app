import coremltools as ct 
import tensorflow as tf

tf.saved_model.LoadOptions(
    allow_partial_checkpoint=True,
    experimental_io_device='/job:localhost',
    experimental_skip_checkpoint=False
)
tf_model = tf.saved_model.load("./HRVClassificationModel21")

mlmodel = ct.convert(tf_model)

tf_prediction = mlmodel.predict([21.33825142,60.42080465,'no'])

print("tf_prediction:", tf_prediction)
