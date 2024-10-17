import numpy as np

def parse_permx(file_path):
    permx_data = []
    is_permx_section = False
    
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith('--'):
                continue  
            
            if line == 'PERMX':
                is_permx_section = True
                continue
            
            if is_permx_section:
                if '/' in line:
                    line = line.replace('/', '')
                    values = line.split()
                    permx_data.extend([float(value) for value in values])
                    break 
                
                values = line.split()
                permx_data.extend([float(value) for value in values])
    
    return permx_data

# Example usage
file_path = 'include/grid/drogon.perm'
permx_values = parse_permx(file_path)
print(len(permx_values))
nb_cell = 46*73*31

assert nb_cell == len(permx_values)

log_Kx = []
for i, Kx in enumerate(permx_values):
    if Kx <= 0.:
        log_Kx.append(Kx)
    else:
        log_Kx.append(np.log(Kx))


np.savez('priormean.npz', PriorMean=log_Kx)



