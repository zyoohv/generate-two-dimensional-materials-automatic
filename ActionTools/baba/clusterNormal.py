import copy
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


class clusterNormal(object):
    """docstring for cluster
    """

    def __init__(self, axis, atom, posi):
        """ for example:
        axis : [vec_a, vec_b, vec_c]
        atom : [[42], [16], [16]]
        posi : [x1, x2, ...]
        """
        self.axis = np.array(axis)
        self.atom = np.array(atom)
        self.posi = np.array(posi)
        self.normal_posi = self.augAtoms()
        self.labels = np.array([])

    def augAtoms(self):
        normal_posi = copy.deepcopy(self.posi)
        for i in range(len(self.posi)):
            thisAtom = normal_posi[i] + self.axis[2]
            normal_posi = np.concatenate((normal_posi, [thisAtom]), axis=0)
            self.atom = np.concatenate((self.atom, [self.atom[i]]), axis=0)
        return np.mat(normal_posi)

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
        return [[int(self.atom[i]), float(self.normal_posi[i, 0]), float(self.normal_posi[i, 1]), float(self.normal_posi[i, 2])] for i in range(self.normal_posi.shape[0]) if self.labels[i] == cat_select]
