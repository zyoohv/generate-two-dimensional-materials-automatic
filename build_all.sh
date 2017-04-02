# dont't edit this file !
# build all dependence automatically
#! /bin/bash -v

cd lib

# download and compile pwscf
echo '########################################'
echo '#             build pwscf              #'
echo '########################################'

QE_VERSION="qe-6.1.tar.gz"

echo $QE_VERSION

wget -O $QE_VERSION http://qe-forge.org/gf/download/frsrelease/240/1075/$QE_VERSION

tar -zxvf $QE_VERSION
cd $QE_VERSION
mkdir build
cd build
cmake ..
make -j4
cd ../../


## download xcrysden
echo '########################################'
echo '#            build xcrysden            #'
echo '########################################'
XCRYSDEN="xcrysden-1.5.60-linux_x86_64-semishared.tar.gz"

wget -O $XCRYSDEN http://www.xcrysden.org/download/$XCRYSDEN

tar -zxvf $XCRYSDEN

