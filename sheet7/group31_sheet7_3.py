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

print train_x.shape
print train_t.shape
print test_x.shape

# plot data
plt.figure(figsize=(10,5))
for i in range(train_x.shape[0]):
    plt.plot(train_x[i][0],train_x[i][1],"bo" if train_t[i] == 1 else "ro")
plt.title("Noisy OR-data")
plt.xlim(-2,2)
plt.ylim(-2,2)

# append x0 = [1,1] to use bias later as w0
# train_x = np.append([[1,1]],train_x,axis=0)
# train_t = np.append([1],train_t)

# choose learning rate as well as threshold
EPSILON = 0.01      # learning rate
THETA = 0.5         # threshold

# define output activation function as given in exercise
def output(y_in):
    return 1 if y_in > THETA else (-1 if y_in < -THETA else 0)

# initialize as many random weights as there are data points
w = np.random.rand(train_x.shape[0],train_x.shape[1])

# bias = w0
bias = np.random.rand(train_x.shape[1])

error = np.ones(12)
# while error.all() > 0:
for j in range(2000):
    for i in range(train_x.shape[0]):
        # get output using activation function of activation = weights*data
        y_in = np.dot(train_x[i],w[i].T)
        y = output(y_in)
        print y

        # update weights and implicitly bias (=w0)
        delta_w = EPSILON*(train_t[i]-y)*train_x[i]
        w[i] += delta_w

        # update bias
        bias += EPSILON*(train_t[i]-y)

    # for stop criterion, calculate error
    # error = 0.5*sum((train_t - np.array(
    #     [output(np.dot(train_x[i],w[i].T)) for i in
    #         range(train_x.shape[0])]))**2)
    # print error

print w 
print bias

plt.gca().quiver(bias[0],bias[1],w.T[0],w.T[1],angles='xy',scale_units='xy',scale=1)
plt.show()

# plot test data
for i in range(test_x.shape[0]):
    plt.plot(test_x[i][0],test_x[i][1],'ro')#,"ro" if test_t[i] == 1 else "bo")
plt.title("Data with Weights")
# plt.xlim(-2,2)
# plt.ylim(-2,2)
plt.show()
