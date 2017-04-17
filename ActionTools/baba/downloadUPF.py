import os


def downloadUPF(filename, outputdir):
        # filename: mg.xxx.UPF
        # outputdir: data/example
    url = 'http://www.quantum-espresso.org/wp-content/uploads/upf_files/'
    cmd = 'wget -O ' + outputdir + '/' + filename + ' ' + url + filename
    os.system(cmd)
