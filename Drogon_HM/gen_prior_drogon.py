import sys
import numpy as np


# noinspection PyUnusedLocal
def gen_prior_ensemble():
    # set the random seed
    np.random.seed(2062021)

    N = 20

    n_satnum = 180 #225
    n_fault = 6
    n_multregt = 3

    prior = {'lw': np.zeros((n_satnum, N)),
             'ew': np.zeros((n_satnum, N)),
             'tw': np.zeros((n_satnum, N)),
             'lo': np.zeros((n_satnum, N)),
             'eo': np.zeros((n_satnum, N)),
             'to': np.zeros((n_satnum, N)),
             'lg': np.zeros((n_satnum, N)),
             'eg': np.zeros((n_satnum, N)),
             'tg': np.zeros((n_satnum, N)),
             'log': np.zeros((n_satnum, N)),
             'eog': np.zeros((n_satnum, N)),
             'tog': np.zeros((n_satnum, N)),
             'krw': np.zeros((n_satnum, N)),
             'krow': np.zeros((n_satnum, N)),
             'krog': np.zeros((n_satnum, N)),
             'krg': np.zeros((n_satnum, N)),
             'fltmlt': np.zeros((n_fault,N)),
             'mltregt': np.zeros((n_multregt,N)),
             }


    for param in prior.keys():
        if param in ['poro']:
            continue
        elif param[0:6] == 'fltmlt':
            prior[param] = np.random.uniform(-2.0,0.0,size=(n_fault, N))
        elif param[0:7] == 'mltregt':
            prior[param] = np.random.uniform(-2.0,0.0,size=(n_multregt, N))
        elif param[0:3] == 'krw': # krw
            #prior[param] = np.random.uniform(0.3,0.7,size=(n_satnum, N))
            prior[param] = np.random.uniform(0.7,1.3,size=(n_satnum, N)) #2
            #prior[param] = np.random.uniform(-1.0,1.0,size=(n_satnum, N)) #5
        elif param[0:2] == 'kr': # kro/g/og
            #prior[param] = np.random.uniform(0.6,1.0,size=(n_satnum, N))
            prior[param] = np.random.uniform(0.7,1.3,size=(n_satnum, N)) #2  This is used for both sets of rates and params shared in this catalog
            #prior[param] = np.random.uniform(-1.0,1.0,size=(n_satnum, N)) #5  NB log10.  This is used for my ongoing pipt-run, hopefule to be shared soon ...
        elif param[0:4] == 'emlt': # emlto/g
            prior[param] = np.random.uniform(0.9,2.1,size=(n_satnum, N))
        elif param[1:3] == 'mlt' : # lmlto/g tmlto/g
            prior[param] = np.random.uniform(1,2,size=(n_satnum, N))
        elif param[0] == 'e' : # ew/o/g/og
            prior[param] = np.random.uniform(-3 , 4,size=(n_satnum, N))
        else : # lw/o/g/og  tw/o/g/og
            prior[param] = np.random.uniform(1.1 , 8.0,size=(n_satnum, N))
            
        print('Generate : ' + param)

    np.savez('prior.npz', **prior)

if __name__ == '__main__':
    gen_prior_ensemble()
