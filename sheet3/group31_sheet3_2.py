#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.spatial.distance import cdist

# load matlab array
data = np.array(loadmat(file_name="points", matlab_compatible=True)['pts'])

# function for agglomerative clustering
def aggl_clustering(data, single_not_complete):
    # give back data if it has less than two elements
    if data.shape[0] < 2:
        return data

    # initialize clusters by putting each data point in another array that
    # represents a cluster, so we get a 200x1x2-array
    # 200 clusters, each with 1 point consisting of 2 coordinates
    clusters = data[:,np.newaxis]
    print clusters
    print clusters.shape

    # if more than five clusters exist do loop
    while clusters.shape[0] > 5:

        # initialize cluster-indices for clusters with smallest distance
        # as well as first smallest opt_dist
        [opt_i,opt_j] = [0,0]
        opt_dist = cdist(clusters[0],clusters[1],'euclidean')

        # double loop through all clusters so far
        for i in range(clusters.shape[0]):
            for j in range(i+1,clusters.shape[0]):

                # get min or max euclidean distance of points
                if single_not_complete:
                    dist = min(cdist(clusters[i],clusters[j],'euclidean'))
                else:
                    dist = max(cdist(clusters[i],clusters[j],'euclidean'))

                # use dist if it is smaller than the distance we had before
                # and update best indices for clusters with smallest distance
                if dist < opt_dist:
                    opt_dist = dist
                    opt_i = i
                    opt_j = j

        print \
        (np.array([np.append(clusters[opt_i],clusters[opt_j],axis=0)])).shape
        print clusters.shape
        clusters = np.append(clusters, \
                np.array([np.append(clusters[opt_i],clusters[opt_j],axis=0)]), \
                axis=0)
        print clusters
        break
        clusters = np.delete(clusters,opt_i,axis=0)
        clusters = np.delete(clusters,opt_j,axis=0)

    return clusters


# actually perform the clustering
clusters = aggl_clustering(data,single_not_complete = True)
plt.figure()
plt.subplot(121)
plt.plot(clusters)

clusters = aggl_clustering(data,single_not_complete = False)
plt.subplot(122)
