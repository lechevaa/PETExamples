import pickle 
import os
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

ml_data_folder = 'En_ml_data/'
figname = 'solver_report_raw'

if os.path.isfile(f'{ml_data_folder}/{figname}.pkl'):
        with open(f'{ml_data_folder}/{figname}.pkl', 'rb') as f:
            raw_dict = pickle.load(f)
            num_iter = len(raw_dict.keys())



data = []
for itern in raw_dict.keys():
      cumNewt = []
      for en in raw_dict[itern]['NewtIt'].keys():
            cumNewt.append(np.sum(raw_dict[itern]['NewtIt'][en]))
      data.append(cumNewt)



plt.figure(figsize=(18, 10))
sns.boxplot(data=data)

# Adding titles and labels
plt.title('Newton iterations')
plt.xlabel('Iteration no.', size=20)
plt.ylabel('Newton iterations per simulation', size=20)

plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
# Show the plot
plt.xticks(ticks=np.arange(num_iter), labels=[f'{i+1}' for i in range(num_iter)])
plt.savefig('newtons.png', dpi=500)
plt.show()

# f.tight_layout(pad=2.0)

# plt.show()
