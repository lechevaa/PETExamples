import os
import shutil
import time
from p_tqdm import p_map
from collections import defaultdict

from pipt.loop.assimilation import Assimilate
from simulator.opm import flow
from input_output import read_config
from pipt import pipt_init


from misc.preconditioning.data_preparation_ml import dataset_preparation
from misc.preconditioning.ml_routine import ml_routine
from misc.preconditioning.figures import plot_solver_report, plot_combined_solver_report

# fix the seed for reproducability
import numpy as np


def process_sim(n, en_i, runfile, sim, well_mode_dict):
    data_path = f"En_ml_data/En_iter_{en_i}/En_{n}_"
    
    # Create the directory if it doesn't exist
    os.makedirs(f"En_{n}", exist_ok=True)
    
    # Check if the file already exists, and copy if it doesn't
    if not os.path.isfile(f"En_{n}" + os.sep + runfile + ".DATA"):
        shutil.copy2(data_path + runfile + '.DATA', f"En_{n}" + os.sep + runfile + ".DATA")
    
    # Call the simulation function
    succes = sim.call_sim(folder=f"En_{n}/", flow_option='flow')
    # prepare dataset right after simulation ended
    dataset_preparation(n, en_i, well_mode_dict)
    return succes 


def find_iter_number(folder_path='En_ml_data'):
    matching_folders = []

    for root, dirs, _ in os.walk(folder_path):
        for dir_name in dirs:
            if dir_name.startswith('En_iter'):
                matching_folders.append(os.path.join(root, dir_name))
    return len(matching_folders)

if __name__ == "__main__":
    np.random.seed(10)
    
    kd, kf = read_config.read_txt('3D_ES.pipt')
    sim = flow(kf)

    ensemble_iter = int(kd['iteration'][0][1])
    ne = int(kd['ne'])
    runfile = kf['runfile'].upper()
    num_proc = int(kf['parallel'])
    well_mode_dict = {'INJ': ['INJ1', 'INJ2', 'INJ3'], 'PROD':['PRO1', 'PRO2', 'PRO3']}
    
    print("Running Standard History Matching")
    analysis = pipt_init.init_da(kd, kf, sim)
    assimilation = Assimilate(analysis)
    start = time.time()
    assimilation.run()
    end = time.time()
    print(f'Time to run Standard History Matching: {end - start:.6f}s')

    # There can be some failed iterations which are not accounted in ensemble_iter
    ensemble_iter = find_iter_number()
    plot_solver_report("En_ml_data", en_i=ensemble_iter,figname='solver_report_standard', newton='standard')

    well_models_history = defaultdict(list)
    well_models_ready = []
    print("Beginning of Hybrid Newton")
    for en_i in range(ensemble_iter):
        print(f"\nRunning ensemble iteration {en_i} and Preparing dataset for training")
        successes = p_map(lambda n: process_sim(n, en_i, runfile, sim, well_mode_dict), range(ne), num_cpus=num_proc)
        fail_indexes = [index for index, value in enumerate(successes) if not value]
        print("Failed simulations: ", fail_indexes)
        # Train or finetune depending on the ensemble iteration
        if en_i == 0:
            print(f"Training")
            well_models_ready = ml_routine(num_proc, en_i, well_models_ready, finetuning=False)
        else:
            print("Finetuning")
            well_models_ready = ml_routine(num_proc, en_i, well_models_ready, finetuning=True)
        well_models_history[en_i] = well_models_ready
        print("Wells ready: ", well_models_ready)
    print("Plot performances")
    plot_solver_report("En_ml_data", en_i=ensemble_iter,figname='solver_report_hybrid', newton='hybrid')
    print(well_models_history)
    plot_combined_solver_report("En_ml_data", en_i=ensemble_iter,figname='solver_report_combined')
