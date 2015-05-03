#!/usr/bin/env python

# imports
import numpy as np
import matplotlib.pyplot as plt
import sklearn as skl
import pydot
from scipy.io import loadmat

# set threshold value as constant
THRESHOLD_VALUE = 3

# implement RosnerTest function
def rosnerTest(zpoints, measure):
    # set zmax-value to start the while-loop, since do-while-loops do not exist in python
    zmax = THRESHOLD_VALUE

    # while there are still outliers
    while zmax >= THRESHOLD_VALUE:

        # get mean/median and standard deviation of data points
        if measure == 'mean':
            zme_an = np.mean(zpoints)
        elif measure == 'median':
            zme_an = np.median(zpoints)
        zstd = np.std(zpoints)

        # initialize our greatest z-value found so far
        zmax = -1

        # calculate z-value for each datapoint and get z-value maximum
        for point in zpoints:
            zvalue = np.abs((point - zme_an))/zstd
            if zvalue > zmax:
                zmax = zvalue
                zmaxpoint = point

        # if maximum z-value is above threshold, remove outlier
        if zmax >= THRESHOLD_VALUE:
            zpoints = np.delete(zpoints, zmaxpoint)

    return zpoints

# get matlab array
zpoints = loadmat(file_name="zPoints", matlab_compatible=True)['x']

# create figure for plots
plt.figure(figsize=(10,12))

# execute Rosner-Test using mean and plot result
# (normally plt.plot would also plot index of numpy array on x-dimension, here a
# array full of 0s is used instead to plot the points above each other)
mean_result = rosnerTest(zpoints,'mean')
rest_zpoints = np.delete(zpoints,mean_result)
plt.subplot(121)
plt.plot(np.zeros(rest_zpoints.shape[0]),rest_zpoints,"ro")
plt.plot(np.zeros(mean_result.shape[0]),mean_result,"o")
plt.ylabel("data-point value")
plt.title("Mean for Z-Value Calculation")

# execute Rosner-Test using median and plot result
median_result = rosnerTest(zpoints,'median')
rest_zpoints = np.delete(zpoints,median_result)
plt.subplot(122)
plt.plot(np.zeros(rest_zpoints.shape[0]),rest_zpoints,"ro")
plt.plot(np.zeros(median_result.shape[0]),median_result,"o")
plt.ylabel("data-point value")
plt.title("Median for Z-Value Calculation")
