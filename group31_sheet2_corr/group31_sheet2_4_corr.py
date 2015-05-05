### 5/5 nothing to add. FH

#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"
__email__ = "jkirchner@uos.de, milsen@uos.de, sakohl@uos.de"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

# set threshold value as constant
THRESHOLD_VALUE = 3

# implement RosnerTest function
def rosnerTest(zpoints, measure):

    outliers = np.empty(0)      # initialize outlier array
    zmax = THRESHOLD_VALUE+1    # set zmax-value to start the while-loop

    # while there are still outliers
    while zmax > THRESHOLD_VALUE:

        # get mean/median and standard deviation of data points
        if measure == 'mean':
            zme_an = np.mean(zpoints)
        elif measure == 'median':
            zme_an = np.median(zpoints)
        zstd = np.std(zpoints)

        # initialize our greatest z-value found so far
        zmax = -1

        # calculate z-value for each datapoint and get z-value maximum
        for i,point in enumerate(zpoints):
            zvalue = np.abs((point - zme_an))/zstd
            if zvalue > zmax:
                zmax = zvalue
                zmaxindex = i

        # if maximum z-value is above threshold, remove outlier
        if zmax > THRESHOLD_VALUE:
            outliers = np.append(outliers,zpoints[zmaxindex])
            zpoints = np.delete(zpoints,zmaxindex)

    # return list with two elements, non-outliers and outliers
    return [zpoints,outliers]

# get matlab array
zpoints = loadmat(file_name="zPoints", matlab_compatible=True)['x']

# create figure for plots
plt.figure(figsize=(10,12))

# execute Rosner-Test using mean and plot result
# (normally plt.plot would also plot index of numpy array on x-dimension, here a
# array full of 0s is used instead to plot the points above each other)
[mean_result,mean_outliers] = rosnerTest(zpoints,'mean')
plt.subplot(121)
plt.plot(np.zeros(mean_result.shape[0]),mean_result,"o")
plt.plot(np.zeros(mean_outliers.shape[0]),mean_outliers,"ro")
plt.ylabel("data-point value")
plt.title("Mean for Z-Value Calculation")

# execute Rosner-Test using median and plot result
[median_result,median_outliers] = rosnerTest(zpoints,'median')
plt.subplot(122)
plt.plot(np.zeros(median_result.shape[0]),median_result,"o")
plt.plot(np.zeros(median_outliers.shape[0]),median_outliers,"ro")
plt.ylabel("data-point value")
plt.title("Median for Z-Value Calculation")
plt.show()
