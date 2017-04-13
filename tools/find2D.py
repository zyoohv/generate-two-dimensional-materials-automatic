#! /usr/bin/python
import sys
import os
import glob
import argparse

sys.path.append('.')
from ActionTools.ClusterAtoms import cluster_from_file


parser = argparse.ArgumentParser()

parser.add_argument('-i', '--input', type=str, help='path of input file.', default='data/example/inp1')
parser.add_argument('--log', type=str, help='log file.', default='data/log')
parser.add_argument('-v', type=int, help='visual result.', default=1, choices=[1, 2, 3])

args = parser.parse_args()


input_file = args.input
log_file = args.log
plot_image = args.v

input_dir, _ = os.path.split(input_file)

cmd = 'lib/find-2D-crystal/src/find2D.x 0<{} 1>{} 2>&1'.format(input_file, log_file)

os.system(cmd)
xsf_list = glob.glob('xsf.*')
for xsf_file in xsf_list:
    os.system('mv {} {}/{}'.format(xsf_file, input_dir, xsf_file))
    print 'Generate "{}/{}" Done.'.format(input_dir, xsf_file)
    prefix, result = cluster_from_file('{}/{}'.format(input_dir, xsf_file), method='KMeans_method', plot_image=2)
    with open('{}/{}_split'.format(input_dir, xsf_file), 'w') as fout:
        for line in prefix:
            fout.write(line)
        fout.write(' {}  1\n'.format(str(len(result))))
        for line in result:
            fout.write(' {}          {}          {}          {}\n'.format(str(line[0]), str(line[1]), str(line[2]), str(line[3])))
    print 'Generate "{}/{}_split" Done.'.format(input_dir, xsf_file)
