#! /usr/bin/python

'''
 &control
    calculation = 'scf'
    restart_mode='from_scratch',
    prefix='feo_af',
    pseudo_dir = '/home/stu/soft/espresso-5.2.1/pseudo/',
    outdir='./'
    tprnfor = .true., tstress=.true.
 /
 &system
    ibrav=  0, celldm(1)=8.19, nat=  4, ntyp= 3,
    ecutwfc = 30.0, ecutrho = 240.0, nbnd=20,
    occupations='smearing', smearing='gauss', degauss=0.01,
 /
 &electrons
    mixing_mode = 'plain'
    mixing_beta = 0.3
    conv_thr =  1.0d-6
    mixing_fixed_ns = 0
 /
CELL_PARAMETERS
0.50 0.50 1.00
0.50 1.00 0.50
1.00 0.50 0.50
ATOMIC_SPECIES
 O1   1.  O.pz-rrkjus.UPF
 Fe1  1.  Fe.pz-nd-rrkjus.UPF
 Fe2  1.  Fe.pz-nd-rrkjus.UPF
ATOMIC_POSITIONS {crystal}
 O1  0.25 0.25 0.25
 O1  0.75 0.75 0.75
 Fe1 0.0  0.0  0.0
 Fe2 0.5  0.5  0.5
K_POINTS {automatic}
2 2 2 0 0 0
'''

from get_upf import *


def scfmodel(prefix, method):
    template = ''' &control
    calculation = '{}'
    restart_mode='from_scratch',
    prefix='{}',
    pseudo_dir = './',
    outdir='./tmp'
    tprnfor = .true., tstress=.true.\n /'''.format(method, prefix)
    return template


def systemmodel(atom):
    template = '''  &system
    ibrav=  0, nat= {}, ntyp= {},
    ecutwfc = 30.0, ecutrho = 240.0, nbnd=20,
    occupations='smearing', smearing='gauss', degauss=0.01, \n/'''.format(len(atom), len(set(atom)))
    return template


def electronsmodel():
	template = '''  &electrons
    mixing_mode = 'plain'
    mixing_beta = 0.3
    conv_thr =  1.0d-6
    mixing_fixed_ns = 0 \n/'''
    return template


def cellparameters(vec):
	template = 'CELL_PARAMETERS\n'
	for v in vec:
		for x in v:
			template = template + str(x) + ' '
		template += '\n'
	return template


def atomspecies(atom, upftpye=None):
	# process upf file here
    if upftpye != 'None':
        flag = search_upf_identity(set(atoms), tp)
        if flag is False:
            print('cannot find upf file: {}'.format(upftpye))
            return
    else:
        upftpye = search_upf_file(set(atoms))
    if upftpye is None:
        print('sorry, cannot find upf file!')
        return
    upflist = [atom[i] + upftpye + '.UPF' for i in range(atom)]

    # debug
    print('upflist = ', upflist)

    template = 'ATOMIC_SPECIES\n'
    for i in range(len(atom)):
    	template += ' {}   1.  {}\n'.format(atom[i], upflist[i])
    return template


def atomposition():
	template = 'ATOMIC_POSITIONS {crystal}\n'
	return template
    

def getscfin(item, atom, vec, outputdir):
    pass
