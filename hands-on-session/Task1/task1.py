#!/usr/bin/env python

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

#------------------------------------------------------------------------------
# load matlab arrays
data = np.array(loadmat("task1a", matlab_compatible=True)['x'])
print data.shape

mean = np.mean(data,axis=0)
var = np.var(data,axis=0)
print mean
print var

plt.figure(figsize=(10,5))
for i,attr in enumerate(data.T):
    plt.hist(attr)
    plt.title(i+1);
    plt.show();

