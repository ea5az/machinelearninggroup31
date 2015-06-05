#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.linalg import eigh

# plot xy_data's two dimensions on x (eruption duration) and y axis (waiting
# time), use categories to determine the points' color (categorization)
# plotpoints is a list with 2 string-entreis like 'go' or 'bx'
def plot_data(data_xy, categories, plotpoints):
    for i,xy in enumerate(data_xy):
        plt.plot(xy[0],xy[1],plotpoints[0] if categories[i] else plotpoints[1])

#------------------------------------------------------------------------------
# load matlab arrays
data_xy = np.array(loadmat("oldfaithful", matlab_compatible=True)['x'])
categories = np.array(loadmat("oldfaithful", matlab_compatible=True)['y'])

# plot data
plt.figure(figsize=(10,5))
plt.subplot(221)
plot_data(data_xy,categories,['ro','bo'])
plt.title("Data")

# normalize data to 0-mean
for i in range(2):
    mean = np.mean(data_xy.T[i]) # get mean of x/y-values in data_xy
    for xy in data_xy:
        xy[i] = xy[i] - mean     # substract it of data_xy

# plot normalized data with 0-mean
plt.subplot(222)
plot_data(data_xy,categories,['ro','bo'])
plt.title("Normalized Data with Eigenvectors")
# the data is structured as before, but now has its mean in (0,0)

# calculate eigenvalues and vectors of covariance matrix:
# use eigh for symmetric matrices, since rounding errors with eig lead to
# complex eigenvalues otherwise
evalues, evectors = eigh(np.cov(data_xy.T))

# output of eigh is sorted in ascending order so we just reverse the vector
# order to get them into descending order
evalues = evalues.T[::-1].T
evectors = evectors.T[::-1].T

# show eigenvectors
plt.quiver(np.zeros(2),np.zeros(2),evectors[0],evectors[1],width=0.005,scale=10)

# TODO is this meant by projections? or just showing the vector above?
# for each eigenvector: add it to data and plot the result in comparison to old
# data
# for i,evector in enumerate(evectors):
#     projection = np.array([xy + evector.T for xy in data_xy])
#     plt.subplot(3,2,3+i)  # change other subplots to 3,2,x
#     plot_data(data_xy,categories,['ro','bo'])
#     plot_data(projection,categories,['rx','bx'])
#     plt.title("Projecting Points Using Eigenvector " + str(i+1))

# reduce dimension space by mapping input on eigenspace (multiplying
# eigenvector(principal component) with data)), plot it
xy_reduced = np.dot(evectors.T[0],data_xy.T)
plt.subplot(223)
for i,x in enumerate(xy_reduced):
    plt.plot(x,0,'ro' if categories[i] else 'bo')
plt.title("One-Dimensional Data Using Second Eigenvector")

# 2.
# reconstruct the data by multiplying the one-dimensional one with our principal
# component, and plot it (with normalized data in the background)
xy_reconstructed = np.array(
        [xy_reduced*evectors.T[0][0],xy_reduced*evectors.T[0][1]]).T
plt.subplot(224)
plot_data(xy_reconstructed,categories,['ro','bo'])
plot_data(data_xy,categories,['rx','bx'])
plt.title("Reconstructed Two-Dimensional Data")

# actually show the figure
plt.show()

