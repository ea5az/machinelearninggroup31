#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt

# create class data arrays
c1 = np.array([[4,1],[2,4],[2,3],[3,6],[4,4]])
c2 = np.array([[9,10],[6,8],[9,5],[8,7],[10,8]])

# calculate means of class data
mu1 = np.mean(c1,axis=0)
mu2 = np.mean(c2,axis=0)

# calculate within-class scatter (p1 was not given but we take 0.5 such that
# both classes have the same a priori probability)
cov1 = np.dot((c1 - mu1).T,(c1-mu1))
cov2 = np.dot((c2 - mu2).T,(c2-mu2))
Sw = 0.5 * cov1 + 0.5 * cov2
# Sw = 0.5 * np.cov(c1.T) + 0.5 * np.cov(c2.T)

# calculate weights using formula given in exercise
w = np.linalg.inv(Sw)*(mu1-mu2)

# plot data
plt.plot(c1.T[0],c1.T[1],'ro')
plt.plot(c2.T[0],c2.T[1],'bo')
plt.plot(w[0],w[1],'b-')
plt.show()

# does not look right, but I just do not have the time at the moment
