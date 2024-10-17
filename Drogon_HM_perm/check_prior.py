import numpy as np

prior_forecast = np.load('posterior_state_estimate.npz', allow_pickle=True)
print(prior_forecast.files)
print(prior_forecast['permx'].shape)

permx_values = prior_forecast['permx'][:, 0]

# log_Kx = []
# for i, Kx in enumerate(permx_values):
#     if Kx <= 0.:
#         log_Kx.append(Kx)
#     else:
#         log_Kx.append(np.log(Kx))

np.savez('priormean_10_0.npz', PriorMean=permx_values)

# prior = np.load('prior.npz', allow_pickle=True)
# print(prior.files)
# print(prior['permx'].shape)