#! /usr/bin/python
import sys
import glob
import argparse

sys.path.append('.')
from ActionTools.get_upf import *

parser = argparse.ArgumentParser()

parser.add_argument('-i', '--input', type=str, help='input file dir', default='data/example')
parser.add_argument('-t', '--type', type=str, help='upf file type', default='None')

args = parser.parse_args()

# set parameters
inputdir = args.i
outputdir = inputdir
tp = args.t

# get atoms dict
atoms_list = []
with open('data/atom_search_list', 'r') as fin:
    atoms_list = [line.strip() for line in fin]


def getscf(atom, vec, upftpye):
    global outputdir

    # process scf.in file
    scfin = ''


# get information from file
filelist = glob.glob(inputdir + '/*.inp.xsf_split')
for filename in filelist:
    file_content = []
    with open(inputdir + '/' + filename, 'r') as fin:
        for line in fin:
            file_content.append([item for item in line if item])
