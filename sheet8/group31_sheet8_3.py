#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

# load matlab array
# (oldfaithful data due to laziness, two input features x and output t)
train_x = np.array(loadmat("train_oldfaithful", matlab_compatible=True)['x'])
train_t = np.array(loadmat("train_oldfaithful", matlab_compatible=True)['t'])
test_t = np.array(loadmat("test_oldfaithful", matlab_compatible=True)['x_test'])

print train_x.shape
print train_t.shape
print test_t.shape

# plot data
plt.figure(figsize=(10,5))
for i in range(train_x.shape[0]):
    plt.plot(train_x[i][0],train_x[i][1],"bo" if train_t[i] == 1 else "ro")
plt.title("Data")
plt.xlim(-2,2)
plt.ylim(-2,2)

# choose learning rate as well as threshold
ALPHA = 0.01     # learning rate
THETA = 0.25     # threshold
HIDDEN_NEURONS_NR = 4 # number of neurons in hidden layer (=p)

# define output activation function and its derivative
# use binary sigmoid function (see 1.2)
f = lambda x: 1.0/(1+np.exp(-x))
f_prime = lambda x: f(x)*(1 - f(x))

# f = lambda y_in: 1 if y_in > THETA else (-1 if y_in < -THETA else 0)
# f_prime = lambda y_in: 1 if y_in > THETA else (-1 if y_in < -THETA else 0)

# initialize random weights (+1 for biases = v0,w0):
# each arc between an input neuron (2+1) and a hidden neuron (HIDDEN_NEURONS_NR)
v = np.random.rand(train_x.shape[1]+1,HIDDEN_NEURONS_NR)
# as well as each arc between a hidden neuron (+1) and the output neuron (k=1)
w = np.random.rand(HIDDEN_NEURONS_NR+1,1)

# append 1-neuron to each training sample to handle bias like weight
train_x = np.append(np.ones((train_x.shape[0],1)),train_x,axis=1)

# biases = v0,w0
# v0 = np.random.rand(HIDDEN_NEURONS_NR)
# w0 = np.random.rand(1) # only one output neuron, only one bias

# initialize error, loop until it reduces to 0 (no sample is miscategorized)
error = np.ones(train_x.shape[0])
while error.any() != 0:            # while the error is bigger than 0
    for i,x in enumerate(train_x): # for each training example

        # sum up weighted x for each z and get output of each z
        # (assumption: each z gets input from all x as seen in picture)
        z_in = np.dot(x,v)
        z = [f(j) for j in z_in]

        # sum up weigthed z for the output neuron y and get output using
        # activation function
        # TODO append 1-neuron to each training sample to handle bias like weight
        y_in = np.dot(z,w)
        y = f(y_in)

        # error information terms (remember: one output neuron, k=1)
        # as many delta_k as output neurons
        # as many delta_in and delta_j as hidden neurons
        delta_k = (train_t[i] - y)*f_prime(y_in)
        delta_in = delta_k*w
        # TODO shouldnt this be HIDDEN_NEURONS_NR long?
        delta_j = np.dot(delta_in.T,f_prime(z_in))

        # weight differences
        diff_w = ALPHA*delta_k*z
        diff_v = ALPHA*delta_j*x

        # update weights and biases
        print w, diff_w
        w += diff_w
        v += diff_v

        # update biases
        # w0 += ALPHA*delta_k
        # v0 += ALPHA*delta_j

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

# bla bla this happens with bigger learning rate smaller learning rate
