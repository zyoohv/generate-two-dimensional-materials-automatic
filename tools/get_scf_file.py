import sys
import glob
import argparse

sys.path.append('.')
from ActionTools.getmodel import getscfin
from ActionTools import *


parser = argparse.ArgumentParser()

parser.add_argument('-i', '--input', type=str,
                    help='input file dir', default='data/example')
parser.add_argument('-t', '--type', type=str,
                    help='upf file type', default='None')

args = parser.parse_args()

# set parameters
inputdir = args.input
outputdir = inputdir
tp = args.type

# get atoms dict
atoms_list = []
atoms_quality = []
with open('data/atom_search_list', 'r') as fin:
    for line in fin:
        thisLine = [item for item in line.strip().split(' ') if item]
        atoms_list.append(thisLine[0])
        atoms_quality.append(float(thisLine[1]))


def getItemName(atom):
    item = ''
    for i in atom:
        item += str(i)
    return item

# get information from file
filelist = glob.glob(inputdir + '/*.inp.xsf_split')
for filename in filelist:
    file_content = []
    with open(filename, 'r') as fin:
        for line in fin:
            file_content.append(
                [item for item in line.strip().split(' ') if item])
    vec = []
    vec.append([float(i) for i in file_content[2]])
    vec.append([float(i) for i in file_content[3]])
    vec.append([float(i) for i in file_content[4]])
    atom = []
    atomq = []
    posi = []
    numofAtoms = int(file_content[10][0])
    for i in range(11, 11 + numofAtoms):
        atom.append(atoms_list[int(file_content[i][0]) - 1])
        atomq.append(atoms_quality[int(file_content[i][0]) - 1])
        posi.append(file_content[i][1:])
    item = getItemName(atom)
    getscfin(item, atom, atomq, vec, posi, scf=True, outputdir=outputdir)
    getscfin(item, atom, atomq, vec, posi, scf=False, outputdir=outputdir)
