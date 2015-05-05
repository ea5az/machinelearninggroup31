#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.stats import norm
from scipy.spatial.distance import cdist

# load matlab array
data = np.array(loadmat(file_name="data", matlab_compatible=True)['x'].flat)

# shuffle the data and split it into three partitions
# (we could just reshape it if we hadn't to divide 200 by 3)
# TODO: not sure whether the size of the partitions should also be random
np.random.shuffle(data)
partitions = [data[:67],data[67:134],data[134:]]
print partitions

# calculate the mean, std and alpha on the partitions
mus = [np.mean(x) for x in partitions]
sigmas = [np.std(x) for x in partitions]
alphas = [x.shape[0]/float(data.shape[0]) for x in partitions]
print mus,sigmas,alphas

# create three gaussian distributions using the parameters
gaussians = [norm.pdf(x=partitions[j],loc=mus[j],scale=sigmas[j]) for j in range(3)]
# TODO q=alphas[i]?

epsilon = 0.1
new_mus = np.array([0,0,0])
new_sigmas = np.array([1,1,1])

# specify linspace and colors for later plotting
ix = np.linspace(-4.5,4,200);
colors = ['b','r','g']

# until they mu and sigma converge
while np.abs(mus - new_mus).all >= epsilon \
  and np.abs(sigmas - new_sigmas).all >= epsilon:
    #E-Step
    # TODO

    #M-Step
    # TODO

    # use given loop to plot the gaussians
    for j in range(0,3):
        plt.plot(ix,norm.pdf(ix,mus[j],sigmas[j])+1,colors[j]);

# show plot
# plt.plot(ix,data,'mo')
plt.show()

