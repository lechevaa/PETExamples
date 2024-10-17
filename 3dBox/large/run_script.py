from pipt.loop.assimilation import Assimilate
from simulator.opm import flow
from input_output import read_config
from pipt import pipt_init
from ensemble.ensemble import Ensemble

# fix the seed for reproducability
import numpy as np
np.random.seed(10)

kd, kf = read_config.read_txt('3D_ES.pipt')
options = {'sim_path': '/home/AD.NORCERESEARCH.NO/anle/pycopm/build/opm-simulators/bin/'}
sim = flow(kf, options=options)

#en = Ensemble(kd,sim)
#en.calc_prediction(save_prediction='prior_prediction')

analysis = pipt_init.init_da(kd, kf, sim)
assimilation = Assimilate(analysis)
assimilation.run()

