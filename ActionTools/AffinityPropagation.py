#! /usr/bin/python

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.cluster import AffinityPropagation
from sklearn.datasets.samples_generator import make_blobs


centers = [[1, 1], [-1, -1], [1, -1]]
X, labels_true = make_blobs(n_samples=30, centers=centers, cluster_std=0.5, random_state=0)

af = AffinityPropagation().fit(X)
cluster_centers_indices = af.cluster_centers_indices_
labels = af.labels_

colors = 'bgrcmyk'

fig = plt.figure()
ax = fig.gca(projection='3d')

for k in range(len(cluster_centers_indices)):
    ax.plot(X[labels == k, 0], X[labels == k, 1], X[labels == k, 1], colors[k] + 'o')

plt.show()
