import pickle
ml_model_folder = 'En_ml_models'
well_names = ['A1', 'A2', 'A3', 'A4', 'A5', 'A6']

def get_min_max_values(scaler):
    min_vals = scaler.min_
    scale_vals = scaler.scale_
    return min_vals, scale_vals

def custom_transform(data, min_vals, scale_vals):
    return (data - min_vals) * scale_vals

def custom_inverse_transform(data, min_vals, scale_vals):
    return data / scale_vals + min_vals

for well_name in well_names:
    scalers_x, scalers_y, scalers_dt = pickle.load(open(ml_model_folder + f'/scalers_{well_name}.pickle', 'rb'))
    for scaler in scalers_y:
        if scaler:
            print(well_name, get_min_max_values(scaler))
    print(well_name, 'dt', get_min_max_values(scalers_dt))