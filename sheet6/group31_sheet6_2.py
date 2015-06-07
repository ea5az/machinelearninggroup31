#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.linalg import eigh

# load matlab array
x = np.array(loadmat("dataLarge1", matlab_compatible=True)['x'])
# x = np.array(loadmat("dataLarge2", matlab_compatible=True)['x'])

# plot data
plt.figure(figsize=(10,5))
plt.plot(x.T[0],x.T[1],"ro")
plt.title("Data with Weights")

# choose learning rate and simulation steps as well as threshold
EPSILON = 0.01      # learning rate
PLOTSTEPS = 100     # plot after how many steps
THRESHOLD = 0.5     # threshold

# define sigmoid activation function using simple step function
def sigma(s):
    return 1 if s > THRESHOLD else 0
    # return np.tanh(s - THRESHOLD) # trying out hyperbolic tangent

# initialize as many random weights as there are data points
w = np.random.rand(x.shape[1])
plt.gca().quiver(w[0],w[1],angles='xy',scale_units='xy',scale=1)
plt.show()

for step in range(x.shape[0]):
    # get output using activation function of activation = weights*data
    y = sigma(np.dot(w,x[step]))

    # use Oja's rule for weight difference
    delta_w = EPSILON*y*(x[step] - y*w)

    # use Hebb's rule
    # delta_w = EPSILON*y*x[step]

    w += delta_w.T

    # plot the weights every 15 steps
    if step%PLOTSTEPS == 0 or step == 999:
        plt.plot(x.T[0],x.T[1],"ro")
        plt.gca().quiver(w.T[0],w.T[1],angles='xy',scale_units='xy',scale=1)
        plt.title("Data with Weights, Step "+str(step))
        plt.show()

# We can see that the vector converges each time to a vector that is orthogonal
# to the main axis of the data:
# As expected our weight vector converges towards the eigenvector of largest
# eigenvalue of C.
cor = np.corrcoef(x)

# Using Oja's rule, the resulting weights for dataLarge1 and dataLarge 2 always
# converge to the same vector.
# Using Hebb's rule, the weight vector for dataLarge1 and dataLarge2 point
# towards the same direction as for Oja's rule but their size increases steadily.
# The increase in size can be easily explained as we always add something to the
# weights when we use Hebb's rule. Oja's rule uses weight decay to prevent the
# steady weight increase.
