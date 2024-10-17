from pipt.loop.assimilation import Assimilate
from simulator.opm import flow
from input_output import read_config
from pipt import pipt_init
from ensemble.ensemble import Ensemble
from popt.update_schemes.enopt import EnOpt

# fix the seed for reproducability
import numpy as np
np.random.seed(10)

kd, kf = read_config.read_txt('drogon_1.pipt')
sim = flow(kf)

#en = Ensemble(kd,sim)
#en.calc_prediction(save_prediction='prior_prediction')

analysis = pipt_init.init_da(kd, kf, sim)
assimilation = Assimilate(analysis)
assimilation.run()


