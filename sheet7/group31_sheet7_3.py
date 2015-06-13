#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

# load matlab array
train_x = np.array(loadmat("train_or", matlab_compatible=True)['x'])
train_t = np.array(loadmat("train_or", matlab_compatible=True)['t'])
test_x = np.array(loadmat("test_or", matlab_compatible=True)['x_test'])

# use oldfaithful data instead if desired
train_x = np.array(loadmat("train_oldfaithful", matlab_compatible=True)['x'])
train_t = np.array(loadmat("train_oldfaithful", matlab_compatible=True)['t'])
test_x = np.array(loadmat("test_oldfaithful", matlab_compatible=True)['x_test'])

# plot data
plt.figure(figsize=(10,5))
for i in range(train_x.shape[0]):
    plt.plot(train_x[i][0],train_x[i][1],"bo" if train_t[i] == 1 else "ro")
plt.title("Data with Decision Boundary (Test Data as xs)")
plt.xlim(-2,2)
plt.ylim(-2,2)

# choose learning rate as well as threshold
EPSILON = 0.01     # learning rate
THETA = 0.25       # threshold

# define output activation function as given in exercise
def output(y_in):
    return 1 if y_in > THETA else (-1 if y_in < -THETA else 0)

# initialize as many random weights as there are input units (2)
w = np.random.rand(train_x.shape[1])

# bias = w0
bias = np.random.randint(-1,1)

# initialize error, loop until it reduces to 0 (no sample is miscategorized)
error = np.ones(train_x.shape[0])
while error.any() != 0:
    for i in range(train_x.shape[0]):

        # get output using activation function
        # (do not forget bias as w0)
        y_in = np.dot(train_x[i],w) + bias
        y = output(y_in)

        # update weights
        delta_w = EPSILON*(train_t[i]-y)*train_x[i]
        w += delta_w

        # update bias
        bias += EPSILON*(train_t[i]-y)

        # update error (how far away ouput is from training result)
        error[i] = train_t[i]-y

# plot decision boundary (defined by function f)
x = np.linspace(-2,2,500)
f = lambda x: -bias - (w[0]/w[1])*x
plt.plot(x,f(x),'m-')

# plot test data as xs 
# color determined whether y-value is greater or lower than f(x)
for i in range(test_x.shape[0]):
    plt.plot(test_x[i][0],test_x[i][1],
            'bx' if f(test_x[i][0]) < test_x[i][1] else 'rx')
plt.show()
