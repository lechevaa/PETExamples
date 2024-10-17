from pipt.loop.assimilation import Assimilate
from simulator.opm import flow
from input_output import read_config
from pipt import pipt_init
from ensemble.ensemble import Ensemble
import time

# fix the seed for reproducability
import numpy as np
np.random.seed(10)
start = time.time()
kd, kf = read_config.read_txt('drogon_1.pipt')
sim = flow(kf)

analysis = pipt_init.init_da(kd, kf, sim)
assimilation = Assimilate(analysis)
assimilation.run()
end = time.time()
print(f'Time to run assimilation: {end - start:.6f}s')

