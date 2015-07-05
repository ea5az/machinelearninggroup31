#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from sklearn import svm

# load matlab array
x_train = np.array(loadmat("data_train", matlab_compatible=True)['x'])
t_train = np.ravel(np.array(loadmat("data_train",
    matlab_compatible=True)['t']))
x_test = np.array(loadmat("data_test", matlab_compatible=True)['x_test'])

# plot the training data with color indicating class
for i,x in enumerate(x_train):
    plt.plot(x[0],x[1], 'ro' if t_train[i] == 1. else 'bo')

# use built-in support vector machine function and fit it to the data,
# data shape is round so we use a radial basis function as a kernel
clf = svm.SVC(kernel='rbf')
clf.fit(x_train,t_train)

# predict test data
t_predict = clf.predict(x_test)

# plot test data
for i,x in enumerate(x_test):
    plt.plot(x[0],x[1], 'rx' if t_predict[i] == 1.  else 'bx')
plt.show()
