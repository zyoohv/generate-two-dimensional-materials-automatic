import glob
import argparse
import numpy as np
import copy
import os
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D

parser = argparse.ArgumentParser()
parser.add_argument('-i', '--input', type=str, help='input file dir', default='data/example')
parser.add_argument('--disnum', type=int, help='split distance', default=50)
args = parser.parse_args()

# we will read scf.in file such as SSMoMoSS.scf.in, so don't put any this kind of
# files in which directory.
scf_in_file = glob.glob(args.input + '/*.scf.in')[0]

def getprimvec(file_content):
    index = np.where(file_content == 'CELL_PARAMETERS\n')[0][0]
    vec = []
    for i in range(index + 1, index + 4):
        line = [float(i) for i in file_content[i].strip().split(' ') if i]
        vec.append(line)
    # print('vec : ', vec)
    return np.array(vec)

# we need calculate with them
# type : np.array
file_content = []
vec = []

with open(scf_in_file, 'r') as fin:
    file_content = np.array([line for line in fin])
    # print('file_content : \n', file_content)
    vec = getprimvec(file_content)

# some config here.
mullow = 0.6
mulhigh = 2
tmp_scf_in = 'scf.in.tmp'
tmp_scf_out = 'scf.out.tmp'
energy = []
dislist = np.linspace(mullow, mulhigh, args.disnum)

def generatefile(origin_file, vec):
    # print('generatefile from origin : \n', origin_file)
    index = np.where(file_content == 'CELL_PARAMETERS\n')[0][0]
    origin_file = list(origin_file)
    for i in range(3):
        origin_file[index + 1 + i] = '{:.6f} {:.6f} {:.6f}\n'.format(vec[i][0], vec[i][1], vec[i][2])
    return origin_file


def generatevec(dismula, dismulb):
    newvec = copy.deepcopy(vec)
    newvec[0], newvec[1] = dismula * vec[0], dismulb * vec[1]
    return newvec


for dismula in dislist:
    for dismulb in dislist:
        print('multipy : {:.2f} {:.2f}'.format(dismula, dismulb), end='  ')
        newvec = generatevec(dismula, dismulb)
        newfile = generatefile(file_content, newvec)

        # store tmp file to tmp_scf_in
        with open(os.path.join(args.input, tmp_scf_in), 'w') as fout:
            for line in newfile:
                fout.write(line)

        # pwscf
        cmd = "cd {}; pw.x < {} | grep '^!' > {}".format(args.input, tmp_scf_in, tmp_scf_out)
        # print('cmd : ', cmd)
        os.system(cmd)

        # get energy
        with open(os.path.join(args.input, tmp_scf_out), 'r') as fin:
            out_file = [line.strip().split(' ') for line in fin][0]
            print('energy=', float(out_file[-2]))
            energy.append([dismula, dismulb, float(out_file[-2])])

energy = np.array(energy)
# print('energy : ', energy)

def get_plot_data(energy, augdis):
    '''
    drawmul = 5
    energy[:, 0:2] *= drawmul
    augdis *= drawmul
    '''
    def findval(x, y):
        for line in energy:
            if line[0] == x and line[1] == y:
                return line[2]

    X = np.array([augdis for _ in range(augdis.shape[0])])
    Y = X.T
    Z = []
    for i in range(augdis.shape[0]):
        line = []
        for j in range(augdis.shape[0]):
            line.append(findval(X[i][j], Y[i][j]))
        Z.append(line)
    return X, Y, Z


X, Y, Z = get_plot_data(energy, dislist)

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

print('X = \n', X)
print('Y = \n', Y)
print('Z = \n', Z)
ax.plot_wireframe(X, Y, Z, rstride=1, cstride=1)

plt.show()
