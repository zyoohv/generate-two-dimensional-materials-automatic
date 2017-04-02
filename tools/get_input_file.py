#! /usr/bin/python
import sys

sys.path.append('.')
from ActionTools import *

scf_in = """&control \
{}\
/
&system \
{}
/
&electrons \
{}
/
ATOMIC_SPECIES \
{}
ATOMIC_POSITIONS \
{}
K_POINTS AUTOMATIC \
{}
""".format(scf_control_model('MoS2', 'output_file', 'scf'), system_model('structure', 2, 2), electrons_model(),
           atomic_species_model(), atomic_positions_model(), k_points())

print scf_in
