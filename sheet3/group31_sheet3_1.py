#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.stats import norm

# load matlab array
data = np.array(loadmat(file_name="data", matlab_compatible=True)['x'].flat)

# shuffle the data and split it into three partitions
# (we could just reshape it if we hadn't to divide 200 by 3)
np.random.shuffle(data)
partitions = [data[:67],data[67:134],data[134:]]

# calculate the mean, std and alpha on the partitions
mus = np.array([np.mean(x) for x in partitions])
sigmas = np.array([np.std(x) for x in partitions])
alphas = np.array([x.shape[0]/float(data.shape[0]) for x in partitions])

# gaussians do not need to be initialized so this is commented out
# gaussians = [norm.pdf(x=partitions[j],loc=mus[j],scale=sigmas[j]) for j in range(3)]

# some arbitrarily chosen epsilon
epsilon = 0.01

# initialize p-matrix and new values for mu, sigma, alpha
p = np.zeros((200,3))
new_mus = mus
new_sigmas = sigmas
new_alphas = alphas

# specify linspace and colors for later plotting
ix = np.linspace(-4.5,4,200);
colors = ['b','r','g']

# start loop
while True:

    # E-Step: estimate probability that data belongs to gaussians
    for i in range(200):
        for j in range(3):
            p[i][j] = norm.pdf(data[i],loc=mus[j],scale=sigmas[j]) * alphas[j]

    # normalize p-values
    p = np.array([p[i]/np.sum(p[i]) for i in range(200)])

    # use given loop to plot the gaussians
    # TODO show plot after each step
    for j in range(3):
        plt.plot(ix,norm.pdf(ix,mus[j],sigmas[j])+1,colors[j])

    # M-Step: estimate new parameters
    for j in range(3):
        new_mus[j] = (1/np.sum(p[j])) * \
                np.sum([p[i][j]*data[i] for i in range(200)])
        new_sigmas[j] = np.sqrt((1/np.sum(p[j])) * \
                np.sum([p[i][j]*(data[i]-new_mus[j])**2 for i in range(200)]))
        new_alphas[j] = np.mean(p[j])

    # break loop if all mus and sigmas converge (their difference is smaller than
    # epsilon), else assign new values to old arrays
    if (np.abs(mus - new_mus) < epsilon).all \
        and (np.abs(sigmas - new_sigmas) < epsilon).all:
        break
    else:
        mus = new_mus
        sigmas = new_sigmas
        alphas = new_alphas

# show plot
plt.plot(ix,data,'mo')
plt.show()

