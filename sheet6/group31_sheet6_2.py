#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.linalg import eigh

# load matlab array
# x = np.array(loadmat("dataLarge1", matlab_compatible=True)['x'])
x = np.array(loadmat("dataLarge2", matlab_compatible=True)['x'])
print x.shape

# plot data
plt.figure(figsize=(10,5))
plt.plot(x.T[0],x.T[1],"ro")
plt.title("Data with Weights")

# choose learning rate and simulation steps
EPSILON = 0.01 # learning rate
STEPS = 600    # simulation steps
PLOTSTEPS = 60 # plot after how many steps

# choose simple thresholding activation function
# in the slides the threshold is called s0 (on the assignment sheet it is called
# theta which is confusing since the actual threshold function (!) is called
# theta in the slides)
THRESHOLD = 0.5    # this is the threshold

# define sigmoid activation function using hyperbolic tangent
def sigma(s):
    return np.tanh(s - THRESHOLD)

# initialize as many random weights as there are data points
w = np.random.rand(x.shape[0])
plt.gca().quiver(w.T[0],w.T[1],angles='xy',scale_units='xy',scale=1)
plt.show()

for step in range(STEPS+1):
    # get output using activation function of activation = weights*data
    y = sigma(np.dot(w,x)) # shape 2

    # use Oja's rule for weight difference
    delta_w = np.dot(EPSILON*y,(x - np.array([w*y[0],w*y[1]]).T).T)

    # use Hebb's rule
    # delta_w = np.dot(EPSILON*y,x.T)

    w += delta_w

    # plot the weights every 15 steps
    if step%PLOTSTEPS == 0:
        plt.plot(x.T[0],x.T[1],"ro")
        plt.gca().quiver(w.T[0],w.T[1],angles='xy',scale_units='xy',scale=1)
        plt.title("Data with Weights, Step "+str(step))
        plt.show()

# we can see that the vector converges each time to a vector that is orthogonal
# to the main axis of the data:
# as expected our weight vector converges towards eigenvector of largest eigenvalue of C
cor = np.corrcoef(x)
# eigv = np.linalg.eigh(cor)
# plt.plot(x.T[0],x.T[1],"ro")
# plt.gca().quiver(eigv[0],eigv[1],angles='xy',scale_units='xy',scale=1)
# plt.title("Eigenvector of correlation matrix")
# plt.show()

# Using Oja's rule, the resulting weights for dataLarge1 and dataLarge 2 always
# converge to the same vector.

# Using Hebb's rule, the weight vector for dataLarge1 goes into the same
# direction as for Oja's rule but its size increases steadily. For dataLarge2 it
# again increases in size without ever stopping.
# The increase in size can be easily explained as we always add something to the
# weights when we use Hebb's rule. Oja's rule uses weight decay to prevent this.
# TODO is the direction different
