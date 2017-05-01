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
        n_clusters = 3
        self.labels = KMeans(n_clusters=n_clusters).fit_predict(
            self.normal_posi[:, 2])


def loadDataFromFile(input_file):
    # process input file.
    # 0  CRYSTAL
    # 1 PRIMVEC
    # 2               3.17084100          0.01615800         -0.21912600
    # 3              -0.01197300          5.50815200          0.21826900
    # 4              -0.29384700          0.55883300          7.26519500
    # 5 CONVVEC
    # 6               3.17084100          0.01615800         -0.21912600
    # 7              -0.01197300          5.50815200          0.21826900
    # 8              -0.29384700          0.55883300          7.26519500
    # 9 PRIMCOORD
    # 10   6  1
    # 11  42          1.63930200          4.92754300          0.27744900
    # 12  42          0.05483500          2.16610900          0.27558600
    # 13  16          0.16924900          0.26703900          1.76227800
    # 14  16          1.74542900          3.02889300          1.76031000
    # 15  16          2.83448100          0.96490700          5.69281800
    # 16  16          1.23644700          3.71157800          5.90873400
    #
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
        atom.append([int(input_model[i][0])])
        posi.append([float(i) for i in input_model[i][1:]])
    return np.array([vec_a, vec_b, vec_c]), np.array(atom), np.array(posi), input_str[:10]


def cluster_from_file(input_file, method='KMeans_method', plot_image=2):
    method_dic = {
        'KMeans_method': KMeans_method
    }

    axis, atom, posi, prefix = loadDataFromFile(input_file)
    # apply cluster method
    doCluster = method_dic[method](axis, atom, posi)
    doCluster.run()

    if plot_image == 3:
        doCluster.paint3D()
    elif plot_image == 2:
        doCluster.paint2D()
    elif plot_image == 1:
        doCluster.paint1D()

    return prefix, doCluster.selectAtom()
