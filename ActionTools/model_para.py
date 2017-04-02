#! /usr/bin/python


def scf_control_model(material, output_file, kind='scf'):
    model = """
    calculation = '{}'
    restart_mode = 'from_scratch',
    prefix = '{}',
    pseudo_dir = '{}',
    outdir = '{}/tmp'
    tstress = .true.
    tprnfor = .true.""".format(kind, material, output_file, output_file)

    return model


def band_control_model(material, output_file):
    model = """
    calculation='bands'
    prefix='{}'
    pseudo_dir = '{}',
    outdir='{}/tmp',""".format(material, output_file, output_file)

    return model


def system_model(structure, nat, ntyp):
    model = """
    {},
    nat={}, ntyp={}, ecutwfc=30, ecutrho=300.0,
    occupations='smearing', smearing='mp', degauss=0.02""".format(structure, nat, ntyp)

    return model


def electrons_model():
    model = """
    electron_maxstep=70
    conv_thr=1.0d-6
    diagonalization='cg'
    mixing_beta=0.7"""

    return model


def atomic_species_model():
    model = """
    Mo  95.94   Mo.pbe-mt_fhi.UPF
    S   32.06   S.pbe-mt_fhi.UPF"""

    return model


def atomic_positions_model():
    model = """
    Mo  0.33333  0.66667  0.25000
    Mo  0.66667  0.33333  0.75000
    S  0.66667  0.33333  0.12100
    S  0.66667  0.33333  0.37900
    S  0.33333  0.66667  0.87900
    S  0.33333  0.66667  0.62100"""

    return model


def k_points():
    model = """
    16 16 16 0 0 0"""

    return model
