from misc.preconditioning.utils import allow_kerasify_import

allow_kerasify_import()
import kerasify

import tensorflow as tf
from tensorflow.keras.models import Model, Sequential
from tensorflow.keras.layers import Input, Dense, Flatten, Concatenate, Reshape

import numpy as np

n_cells = 10
n_features = 3
n_data = 2
test_x = np.random.rand(n_data, n_cells, n_features).astype('f')
test_scalar = np.ones((n_data, 1))

#test_x = np.reshape(test_x, (n_data, n_features*n_cells))
# test_input = np.hstack([test_x, test_scalar])


# print(model.predict(test_x).shape)
# kerasify.export_model(model, 'test.model')
