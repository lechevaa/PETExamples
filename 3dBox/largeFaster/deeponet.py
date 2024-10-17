import tensorflow as tf
from tensorflow.keras.layers import Dense, Dot, Reshape
from tensorflow.keras.models import Model
from tensorflow.keras import backend as K
import os
import numpy as np
import pickle
import random
from sklearn.preprocessing import MinMaxScaler
from misc.preconditioning.utils import allow_kerasify_import
allow_kerasify_import()
from kerasify import export_model
from tensorflow.keras.saving import load_model
from tensorflow.keras.layers import Layer

random.seed(42)
np.random.seed(42)
tf.random.set_seed(42)


def create_scalers_fit_transform(x, y, dt, resvs, well_local_domain):
    # Assuming X = (Po, Sw, Sg, RV, RS, Kx, Ky, Kz), Y = (Po, Sw, Sg, RV, RS)
    y_shape = y[:, :, 1].shape
    x_shape = x[:, :, 1].shape
    # Sw, Sg do need scaling
    scaler_resv = MinMaxScaler()
    resvs = scaler_resv.fit_transform(np.log1p(np.abs(resvs)).reshape(-1, 1))

    scaler_wld = MinMaxScaler()
    well_local_domain = scaler_wld.fit_transform(np.array(well_local_domain).reshape(-1, 1))

    scaler_x_p = MinMaxScaler()
    x[:, :, 0] = scaler_x_p.fit_transform(np.log10(x[:, :, 0]).reshape(-1, 1)).reshape(x_shape)

    scaler_y_p = MinMaxScaler()
    y[:, :, 0] = scaler_y_p.fit_transform(np.log10(y[:, :, 0]).reshape(-1, 1)).reshape(y_shape)

    scaler_x_sw = MinMaxScaler()
    x[:, :, 1] = scaler_x_sw.fit_transform(x[:, :, 1].reshape(-1, 1)).reshape(x_shape)

    scaler_y_sw = MinMaxScaler()
    y[:, :, 1] = scaler_y_sw.fit_transform(y[:, :, 1].reshape(-1, 1)).reshape(y_shape)

    scaler_x_sg = MinMaxScaler()
    x[:, :, 2] = scaler_x_sg.fit_transform(x[:, :, 2].reshape(-1, 1)).reshape(x_shape)

    scaler_y_sg = MinMaxScaler()
    y[:, :, 2] = scaler_y_sg.fit_transform(y[:, :, 2].reshape(-1, 1)).reshape(y_shape)

    scaler_x_RV = MinMaxScaler()
    x[:, :, 3] = scaler_x_RV.fit_transform(np.log10(1e-7 + x[:, :, 3]).reshape(-1, 1)).reshape(x_shape)

    scaler_y_RV = MinMaxScaler()
    y[:, :, 3] = scaler_y_RV.fit_transform(np.log10(1e-7 + y[:, :, 3]).reshape(-1, 1)).reshape(y_shape)

    scaler_x_RS = MinMaxScaler()
    x[:, :, 4] = scaler_x_RS.fit_transform(np.log1p(x[:, :, 4]).reshape(-1, 1)).reshape(x_shape)

    scaler_y_RS = MinMaxScaler()
    y[:, :, 4] = scaler_y_RS.fit_transform(np.log1p(y[:, :, 4]).reshape(-1, 1)).reshape(y_shape)

    scaler_Kx = MinMaxScaler()
    x[:, :, 5] = scaler_Kx.fit_transform(np.log10(x[:, :, 5].reshape(-1, 1))).reshape(x_shape)

    scaler_Ky = MinMaxScaler()
    x[:, :, 6] = scaler_Ky.fit_transform(np.log10(x[:, :, 6].reshape(-1, 1))).reshape(x_shape)

    scaler_Kz = MinMaxScaler()
    x[:, :, 7] = scaler_Kz.fit_transform(np.log10(x[:, :, 7].reshape(-1, 1))).reshape(x_shape)

    return  x, y, dt, resvs, well_local_domain

def load_well_data(datapath):
    data_np = np.load(datapath)
    dyn_props_X = data_np['dyn_props_X']
    dyn_props_Y = data_np['dyn_props_Y']
    static_props = data_np['stat_props']
    dts = data_np['dt']
    resv = data_np['RESV']
    return dyn_props_X, dyn_props_Y, static_props, dts, resv

data_folder = 'En_ml_data_deeponet'
well_name = [item for item in os.listdir(data_folder) if os.path.isdir(os.path.join(data_folder, item)) and item not in ['ToF']][1]
X, Y, dts, resvs = [], [], [], []
paths = os.listdir(data_folder + os.sep + well_name)
for path in paths:
    npz_files = os.listdir(data_folder + os.sep + well_name + os.sep + path)
    for npz in npz_files:
        if npz.endswith('npz'):
            dyn_props_X, dyn_props_Y, static_props, dt, resv = load_well_data(data_folder + os.sep + well_name + os.sep + path + os.sep + npz)
            X.append(np.concatenate([dyn_props_X, static_props], axis=2))
            Y.append(dyn_props_Y)
            dts.append(dt)
            resvs.append(resv)

X = np.concatenate(X)
Y = np.concatenate(Y)
dts = np.array(dts)
resvs = np.array(resvs)

## Convert SGAS to SOIL 
X[:, :, 2] = 1. - X[:, :, 1] - X[:, :, 2]
Y[:, :, 2] = 1. - Y[:, :, 1] - Y[:, :, 2]

well_local_domains = pickle.load(open(data_folder + os.sep + 'well_dict_local.pkl', 'rb'))[well_name]['f']
X_scaled, Y_scaled, dt_scaled, resv_scaled, well_local_domain_scaled = create_scalers_fit_transform(X, Y, dts, resvs, well_local_domains)

resv_scaled = np.broadcast_to(resv_scaled[:, np.newaxis, :], (X_scaled.shape[0], X_scaled.shape[1], 1))
X_scaled = np.concatenate([X_scaled, resv_scaled], axis=2)

n_cells, n_features = X_scaled.shape[1], X_scaled.shape[2]

dt_scaled = dt_scaled[:, np.newaxis, np.newaxis]
well_local_domain_scaled = well_local_domain_scaled[np.newaxis, :, :]

#np.concatenate(well_local_domain_scaled, dt_scaled)
trunk_input = np.concatenate((dt_scaled + np.zeros_like(well_local_domain_scaled), well_local_domain_scaled + np.zeros_like(dt_scaled)), axis=2)



class EinsumLayer(Layer):
    def __init__(self, **kwargs):
        super(EinsumLayer, self).__init__(**kwargs)
    
    def call(self, inputs):
        branch_output, trunk_output = inputs
        return tf.einsum('bci,bcj->bc', branch_output, trunk_output)

    def get_config(self):
        base_config = super(EinsumLayer, self).get_config()
        return {**base_config}
    
# Define input shapes
branch_input_shape = (n_cells, n_features)

# Cell index + dt
trunk_input_shape = (n_cells, 2)

# Define input layers
trunk_inputs = tf.keras.Input(shape=trunk_input_shape, name='trunk_input')
branch_inputs = tf.keras.Input(shape=branch_input_shape, name='branch_input')

# Define the trunk network
trunk_model = tf.keras.Sequential([
    Dense(128, activation='sigmoid', kernel_initializer="glorot_normal", input_shape=trunk_input_shape),
    Dense(64, activation='sigmoid', kernel_initializer="glorot_normal"),
    Dense(16)
], name='trunk')

# Define the branch network
branch_model = tf.keras.Sequential([
    Dense(128, activation='sigmoid', kernel_initializer="glorot_normal", input_shape=branch_input_shape),
    Dense(64, activation='sigmoid', kernel_initializer="glorot_normal"),
    Dense(16)
], name='branch')

# Combine outputs using dot product
trunk_output = trunk_model(trunk_inputs)
branch_output = branch_model(branch_inputs)

# combined = tf.einsum('bci,bcj->bc', branch_output, trunk_output)
combined = EinsumLayer()([branch_output, trunk_output])

z = Dense(128, activation='sigmoid', kernel_initializer="glorot_normal")(combined)
output = Dense(n_cells * (n_features - 4))(z)
output = Reshape((n_cells, (n_features - 4)))(output)

model = Model(inputs=[branch_inputs, trunk_inputs], outputs=output)


# @tf.keras.utils.register_keras_serializable()
# def relative_root_mean_squared_error(y_true, y_pred):
#     numerator = K.sqrt(K.sum(K.square(y_true - y_pred), axis=-1))
#     denominator = K.sqrt(K.sum(K.square(y_true), axis=-1))
#     return K.mean(numerator / (denominator + K.epsilon()))


model.compile(optimizer='adam', loss='mse')

model.summary()

# export_model(model, 'deeponet.model')
custom_objects = {'EinsumLayer': EinsumLayer}
model.fit([X_scaled, trunk_input], Y_scaled, epochs=20)
model_path = 'deeponet_kerasify.tf'
model.save(model_path, save_format="tf")
best_model = load_model(model_path, custom_objects=custom_objects, compile=False)
