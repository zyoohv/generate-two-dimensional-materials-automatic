#! /usr/bin/python

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


class clusterNormal(object):
    """docstring for cluster
    """

    def __init__(self, axis, atom, posi, initlen):
        self.axis = axis
        self.atom = atom
        self.posi = posi
        self.normal_posi = self.makePositive(posi * axis.I)
        self.initlen = initlen
        self.labels = []

    def makePositive(self, normal_posi):
        m, n = normal_posi.shape
        for i in range(m):
            for j in range(n):
                if normal_posi[i, j] < 0:
                    normal_posi[i, j] += 1
        return normal_posi

    def paint2D(self):
        colors = 'bgrcmyk' * 10
        fig = plt.figure()
        ax = fig.add_subplot(111)
        for i in range(len(self.normal_posi)):
            ax.scatter(float(self.normal_posi[i, 0]), float(self.normal_posi[i, 2]),
                       c=colors[self.labels[i]], s=float(self.atom[i]) * 5)
        plt.show()

    def paint3D(self):
        colors = 'bgrcmyk' * 10
        fig = plt.figure("g2dma")
        ax = fig.gca(projection='3d')

        for i in range(len(self.normal_posi)):
            ax.scatter(float(self.normal_posi[i, 0]), float(self.normal_posi[i, 1]), float(self.normal_posi[i, 2]),
                       c=colors[self.labels[i]], s=float(self.atom[i]) * 5)
        plt.show()

    def selectAtom(self):
        cat_count = []
        for k in range(max(self.labels) + 1):
            cat_count.append(sum(self.labels == k))
        cat_select = np.argmax(cat_count)
        return [[int(self.atom[i]), float(self.posi[i, 0]), float(self.posi[i, 1]), float(self.posi[i, 2])]
                for i in range(self.initlen) if self.labels[i] == cat_select]
