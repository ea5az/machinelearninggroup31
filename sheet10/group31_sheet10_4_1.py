#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
import sklearn.naive_bayes as bayes

# load matlab array
x_train = np.array(loadmat("mnist_train_09", matlab_compatible=True)['x_train'])
t_train = np.ravel(np.array(loadmat("mnist_train_09",
    matlab_compatible=True)['t_train']))
x_test = np.array(loadmat("mnist_test_09", matlab_compatible=True)['x_test'])
t_test = np.ravel(np.array(loadmat("mnist_test_09",
    matlab_compatible=True)['t_test']))

# calculate a priori-probabilities:
# initialize array with len=number of classes
priori = np.zeros(int(np.max(t_train))+1)

# for each class example increment class count
for cl in t_train:
    priori[int(cl)]+=1

# divide by amount of examples overall
priori =  priori / t_train.shape

# use naive Bayes classifier
clf = bayes.GaussianNB().fit(x_train,t_train)
t_predict = clf.predict(x_test)

# since we do not know how the visualization should actually look like (the
# exercise is not very clear on that) we just show a dot for each test example
# with its color indicating a correct (green) or incorrect (red) classification
for i,x in enumerate(x_test):
    plt.plot(i, 0, 'go' if int(t_test[i]) == int(t_predict[i]) else 'ro')

    # to actually see something: show plot once every fifth of the test data
    if (i%(x_test.shape[0]/5) == 0 or i == x_test.shape[0]-1) and i != 0:
        plt.show()

