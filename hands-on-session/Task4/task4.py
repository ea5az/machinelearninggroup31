#!/usr/bin/env python

# imports
from sklearn . decomposition import PCA
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

#------------------------------------------------------------------------------
# load matlab arrays
x = np.array(loadmat("wine", matlab_compatible=True)['x'])
y = np.array(loadmat("wine", matlab_compatible=True)['y'])

mean = np.mean(x,axis=0)
var = np.var(x,axis=0)
print mean
print var

pca = PCA(n_components=2).fit(x)
pcs = pca.transform(x)

plt.figure(figsize=(10,5))
for i in range(x.shape[1]):
    plt.plot(i,x.T[i],'ro' if y[i] == 1. else 'bo' if y[i] == 2. else 'go');
plt.show();

pcs
