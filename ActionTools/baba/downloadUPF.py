import os


def downloadUPF(filename, outputdir):
    # filename: mg.xxx.UPF
    # outputdir: data/example
    if os.path.isfile(outputdir + '/' + filename):
        print(outputdir + '/' + filename + ' has exited !')
    else:
        print('download file : ' + outputdir + '/' + filename)
        url = 'http://www.quantum-espresso.org/wp-content/uploads/upf_files/'
        cmd = 'wget -O ' + outputdir + '/' + filename + ' ' + url + filename
        os.system(cmd)
