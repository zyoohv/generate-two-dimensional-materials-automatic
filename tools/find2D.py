#! /usr/bin/python

import os
import argparse

parser = argparse.ArgumentParser()

parser.add_argument('-i', '--input', type=str, help='path of input file', default='data/example/inp1')
parser.add_argument('--log', type=str, help='log file', default='data/log')


args = parser.parse_args()

input_file = args.input
log_file = args.log

input_dir, _ = os.path.split(input_file)

cmd = 'lib/find-2D-crystal/src/find2D.x 0<{} 1>{} 2>&1'.format(input_file, log_file)

os.system(cmd)
os.system('mv xsf.* {}'.format(input_dir))

print 'generate xsf file done.'
