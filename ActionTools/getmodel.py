from ActionTools.baba.get_upf import *
from ActionTools.baba.downloadUPF import downloadUPF


def scfmodel(item, method):
    # prefix: MoS2
    # method: scf/nscf
    template = ''' &control
    calculation = '{}'
    restart_mode='from_scratch',
    prefix='{}',
    pseudo_dir = './',
    outdir='./tmp'
    tprnfor = .true., tstress=.true.\n /\n'''.format(method, item)
    return template


def systemmodel(atom):
    # atom: ['Mo', 'S', 'S']
    template = '''  &system
    ibrav= 0, nat= {}, ntyp= {},
    ecutwfc = 30.0, ecutrho = 240.0, nbnd=20,
    occupations='smearing', smearing='gauss', degauss=0.01, \n/\n'''.format(len(atom), len(set(atom)))
    return template


def electronsmodel():
    template = '''  &electrons
    mixing_mode = 'plain'
    mixing_beta = 0.3
    conv_thr =  1.0d-6
    mixing_fixed_ns = 0 \n/\n'''
    return template


def cellparameters(vec):
    # vec: [vec_a, vec_b, vec_c]
    # vec_x: [float, float, float]
    template = 'CELL_PARAMETERS\n'
    for v in vec:
        for x in v:
            template = template + str(x) + ' '
        template += '\n'
    return template


def atomspecies(atom, atomq, outputdir, upftpye='None'):
    # atom: ['Mo', 'S', 'S']
    # process upf file here
    if upftpye != 'None':
        flag = search_upf_identity(set(atom), upftpye)
        if flag is False:
            print('Error: cannot find upf file {}'.format(upftpye))
            return
    else:
        upftpye = search_upf_file(set(atom))
    if upftpye is None:
        print('Error, cannot find upf file!')
        return
    upflist = [str(i) + '.' + upftpye + '.UPF' for i in atom]

    # debug
    print('upflist = ', set(upflist))

    template = 'ATOMIC_SPECIES\n'
    flag = [True] * len(atom)
    for i in range(0, len(atom)):
        for j in range(0, i):
            if atom[i] == atom[j]:
                flag[i] = False
                break
    for i in range(len(atom)):
        if not flag[i]:
            continue
        # os.system('wget ....')
        downloadUPF(upflist[i], outputdir)
        template += ' {}   {}   {}\n'.format(atom[i], atomq[i], upflist[i])
    return template


def atomposition(atom, posi):
    template = 'ATOMIC_POSITIONS {crystal}\n'
    for i in range(len(atom)):
        template += ' {}  {} {} {}\n'.format(atom[i],
                                             posi[i][0], posi[i][1], posi[i][2])
    return template


def kpoints():
    template = 'K_POINTS {automatic}\n'
    template += '2 2 2 0 0 0'
    return template


def getscfin(item, atom, atomq, vec, posi, scf, outputdir):
    # item: MoS2
    # atom: ['Mo', 'S', 'S']
    # vec: [vec_a, vec_b, vec_c]
    # posi: [[a, b, c], ...]
    # scf: True / False
    # outdir: data/example/atom.scf.in
    print('item : ', item)
    print('atom : ', atom)
    print('scf/nscf : ', 'scf' if scf else 'nscf')
    print('outputdir : ', outputdir)
    scfResult = ''
    scfResult += scfmodel(item, 'scf' if scf else 'nscf')
    scfResult += systemmodel(atom)
    scfResult += electronsmodel()
    scfResult += cellparameters(vec)
    scfResult += atomspecies(atom, atomq, outputdir)
    scfResult += atomposition(atom, posi)
    scfResult += kpoints()
    filename = '%s.%s.in' % (item, 'scf' if scf else 'nscf')
    with open(outputdir + '/' + filename, 'w') as fout:
        fout.write(scfResult)
    print('Generate file %s finished !' % (filename))
