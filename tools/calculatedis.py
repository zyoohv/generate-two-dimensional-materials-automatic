import glob
import argparse
import numpy as np
import copy
import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


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
mulhigh = 3
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


def generatevec(dismul, vec):
    newvec = copy.deepcopy(vec)
    newvec[2] *= dismul
    return newvec


for dismul in dislist:
    newvec = generatevec(dismul, vec)
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
    maxval = -np.inf
    with open(os.path.join(args.input, tmp_scf_out), 'r') as fin:
        out_file = [line.strip().split(' ') for line in fin]
        eval = maxval if len(out_file) == 0 else float(out_file[0][-2])
        maxval = max(maxval, eval)
        print('dismul= {:.2f}, energy= {}'.format(dismul, eval))
        energy.append([dismul, eval])

energy = np.array(energy)
# print('energy : ', energy)

fig = plt.figure()
ax = fig.add_subplot(111)

print('X = \n', energy[:, 0])
print('Y = \n', energy[:, 1])
ax.plot(energy[:, 0], energy[:, 1], 'k-')

plt.savefig('result.jpg')
