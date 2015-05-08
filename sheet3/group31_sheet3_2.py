#!/usr/bin/env python
__author__ = "Jan Hendrik Kirchner, Max Bernhard Ilsen, Sandra Kohl"

# imports
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from scipy.spatial.distance import cdist

# load matlab array
data = np.array(loadmat(file_name="points", matlab_compatible=True)['pts'])
# data = np.array([[1,1],[2,2],[3,3],[4,4],[5,5],[6,6]])

# function for agglomerative clustering
def aggl_clustering(data, single_not_complete):
    # give back data if it has less than two elements
    if data.shape[0] < 2:
        return data

    # initialize clusters by putting each data point in another array that
    # represents a cluster, so we get a 200x1x2-array
    # 200 clusters, each with 1 point consisting of 2 coordinates
    clusters = [np.array([x]) for x in data]

    # if more than five clusters exist do loop
    while len(clusters) > 5:

        # initialize cluster-indices for clusters with smallest distance
        # as well as the first distance between clusters (dist)
        # as well as first smallest  distance between clusters (opt_dist)
        [opt_i,opt_j] = [0,1]
        dist = cdist(clusters[0],clusters[1],'euclidean')[0][0]
        opt_dist = cdist(clusters[0],clusters[1],'euclidean')[0][0]

        # double loop through all clusters so far
        for i in range(len(clusters)):
            for j in range(i+1,len(clusters)):

                # get cluster distance for clusters[i] and clusters[j]:
                # minimum or maximum distance between points depending on single
                # or complete linkage clustering
                for pointi in clusters[i]:
                    for pointj in clusters[j]:
                        # get euclidean distance of points
                        point_dist = cdist(
                                np.array([pointi]),np.array([pointj]),'euclidean')[0][0]

                        # for single linkage clustering take minimum value, else
                        # maximum value
                        if single_not_complete and point_dist < dist:
                            dist = point_dist
                        elif not(single_not_complete) and point_dist > dist:
                            dist = point_dist

                # use cluster distance if it is smaller than the distance we had before
                # update best indices for clusters with smallest distance
                if dist < opt_dist:
                    opt_dist = dist
                    opt_i = i
                    opt_j = j

        # append combined cluster (created with smallest distance clusters) to
        # original cluster array, delete old smallest distance clusters
        clusters.append(np.append(clusters[opt_i],clusters[opt_j],axis=0))
        del clusters[opt_i]
        if opt_i < opt_j:
            del clusters[opt_j-1]
        else:
            del clusters[opt_j]
        print len(clusters) # get a cool cluster-countdown while waiting

    return clusters

colors = ['ro','go','yo','mo','bo']
plt.figure(figsize=(10,12))

# perform single linkage clustering and plotresult
clusters = aggl_clustering(data,single_not_complete = True)
plt.subplot(121)
for i,cluster in enumerate(clusters):
    for point in cluster:
        plt.plot(point[0],point[1],colors[i])
plt.title('Single Linkage Clustering')

# perform complete linkage clustering and plotresult
clusters = aggl_clustering(data,single_not_complete = False)
plt.subplot(122)
for i,cluster in enumerate(clusters):
    for point in cluster:
        plt.plot(point[0],point[1],colors[i])
plt.title('Complete Linkage Clustering')

plt.show()
