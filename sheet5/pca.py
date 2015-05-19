#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.stats import norm
from scipy.linalg import eig

# plot xy_data's two dimensions on x (eruption duration) and y axis (waiting
# time), use categories to determine the points' color (categorization)
def plot_data(data_xy, categories):
    for i,xy in enumerate(data_xy):
        plt.plot(xy[0],xy[1],'ro' if categories[i] else 'bo')

#------------------------------------------------------------------------------
# load matlab arrays
data_xy = np.array(loadmat("oldfaithful", matlab_compatible=True)['x'])
categories = np.array(loadmat("oldfaithful", matlab_compatible=True)['y'])

# plot data
plt.figure(figsize=(10,5))
plt.subplot(121)
plot_data(data_xy,categories)
plt.title("Data")

# normalize data to 0-mean
x_mean = np.mean(data_xy.T[0]) # get mean of x-values in data_x
for xy in data_xy:
    xy[0] = xy[0] - x_mean     # substract it from each x-value

# plot normalized data with 0-mean
plt.subplot(122)
plot_data(data_xy,categories)
plt.title("Normalized Data with Eigenvector Projections")

# calculate eigenvalues and vectors of covariance matrix
evalues, evectors = eig(np.cov(data_xy))

# sort eigenvalues and eigenvectors using evalues as keys for lexsort,
# reverse them with [::-1] so they are in descending order
indices = np.lexsort((evectors.T[0],evalues))
evectors = np.array([evectors[i] for i in indices])[::-1]
evalues = np.array([evalues[i] for i in indices])[::-1]

# print evalues
# print evectors
# TODO plot projections
# plt.plot()

# reducing dimension space, mapping input on eigenspace
# xy_reduced = evectors.T*data_xy
# print xy_reduced

# actually show the figure
plt.show()

# 2.

# reconstruct the data by multiplying it with the
# xy_ reconstructed = xy_reduced *inv(evectors.T)
