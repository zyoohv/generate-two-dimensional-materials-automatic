import numpy as np
from ActionTools.baba.clusterNormal import clusterNormal
from sklearn.cluster import KMeans
from sklearn.cluster import AffinityPropagation
from sklearn.cluster import MeanShift, estimate_bandwidth
from sklearn.cluster import DBSCAN
from sklearn.datasets.samples_generator import make_blobs


class DBSCAN_method(clusterNormal):
    """docstring for DBSCAN_method"""

    def run(self):
        db = DBSCAN(eps=2, min_samples=1).fit(self.normal_posi[:, 2])
        self.labels = db.labels_


class MeanShift_method(clusterNormal):
    """docstring for MeanShift_method"""

    def run(self):
        bandwidth = estimate_bandwidth(
            self.normal_posi, quantile=0.2, n_samples=len(normal_posi))
        ms = MeanShift(bandwidth=bandwidth, bin_seeding=True)
        ms.fit(self.normal_posi)

        self.labels = ms.labels_


class AffinityPropagation_method(clusterNormal):
    """docstring for AffinityPropagation_method"""

    def run(self):
        af = AffinityPropagation().fit(self.normal_posi[:, 2])
        cluster_centers_indices = af.cluster_centers_indices_
        self.labels = af.labels_


class KMeans_method(clusterNormal):
    """docstring for KMeans_method"""

    def run(self):
        n_clusters = 2
        self.labels = KMeans(n_clusters=n_clusters).fit_predict(
            self.normal_posi[:, 2])


def cluster_from_file(input_file, method='KMeans_method', plot_image=2):
    method_dic = {
        'KMeans_method': KMeans_method
    }

    # process input file.
    input_model = []
    input_str = []
    with open(input_file, 'r') as fin:
        for line in fin:
            input_str.append(str(line))
            input_model.append([i for i in line.split(' ') if i])
    vec_a = np.array([float(i) for i in input_model[2]])
    vec_b = np.array([float(i) for i in input_model[3]])
    vec_c = np.array([float(i) for i in input_model[4]])
    numofAtom = int(input_model[10][0])
    atom = []
    posi = []
    for i in range(11, 11 + numofAtom):
        atom.append(np.array([int(input_model[i][0])]))
        posi.append(np.array([float(i) for i in input_model[i][1:]]))

    def appendData():
        for i in range(len(posi)):
            posi.append(posi[i] + vec_a)
            posi.append(posi[i] - vec_a)
            posi.append(posi[i] + vec_b)
            posi.append(posi[i] - vec_b)
            posi.append(posi[i] + vec_a + vec_b)
            posi.append(posi[i] - vec_a - vec_b)
            posi.append(posi[i] + vec_a - vec_b)
            posi.append(posi[i] - vec_a + vec_b)
            atom.append(atom[i])
            atom.append(atom[i])
            atom.append(atom[i])
            atom.append(atom[i])
            atom.append(atom[i])
            atom.append(atom[i])
            atom.append(atom[i])
            atom.append(atom[i])

    # apply cluster method
    initlen = len(atom)
    appendData()
    doCluster = method_dic[method](
        np.mat([vec_a, vec_b, vec_c]), np.mat(atom), np.mat(posi), initlen)

    doCluster.run()
    if plot_image == 3:
        doCluster.paint3D()
    elif plot_image == 2:
        doCluster.paint2D()

    return input_str[:10], doCluster.selectAtom()
