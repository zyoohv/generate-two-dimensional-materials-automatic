# Generate 2-Dimensional Materials automatic

## Install Require

1. `Anaconda3`
2. `gfortran`

*note: it can run in linux-x64 only, we don't support other platforms.*


## Question

1. What's means of it ?

>   6）、k点取样的设置，也就是K_POINTS 后面的设置：   
>   K_POINTS (automatic) 表示由程序采用M-P方法自动确定k点，需给出k点取样网格的大小，以及是否在产生k点后对这些点进行平移。   
>   8 8 8 0 0 0   
>   表示采用8x8x8的网格来确定k点，而且不对k点进行平移。  

2. Troubles: what's wrong with it ?

we can't get expectation viewing with `xcrysden`, we don't know how to deal with
atoms position.

```
&control
   calculation = 'scf'
   restart_mode='from_scratch',
   prefix='SSMoMoSS',
   pseudo_dir = './',
   outdir='./tmp'
   tprnfor = .true., tstress=.true.
/
 &system
   ibrav= 0, nat= 12, ntyp= 2,
   ecutwfc = 30.0, ecutrho = 240.0, nbnd=50,
   occupations='smearing', smearing='gauss', degauss=0.01,
/
 &electrons
   mixing_mode = 'plain'
   mixing_beta = 0.3
   conv_thr =  1.0d-6
   mixing_fixed_ns = 0
/
CELL_PARAMETERS
9.512523 0.048474 -0.657378
-0.011973 5.508152 0.218269
-0.293847 0.558833 7.265195
ATOMIC_SPECIES
S   32.06   S.pbe-mt_fhi.UPF
Mo   95.94   Mo.pbe-mt_fhi.UPF
ATOMIC_POSITIONS {crystal}
S  7.793264 3.620042 8.587253
S  6.217084 0.858188 8.589221
Mo  6.102670 2.757258 7.102529
Mo  7.687137 5.518692 7.104392
S  7.578129 3.743894 5.470482
S  9.176163 0.997223 5.254566
S  2.834481 0.964907 5.692818
S  1.236447 3.711578 5.908734
Mo  1.345455 5.486376 7.542644
Mo  -0.239012 2.724942 7.540781
S  -0.124598 0.825872 9.027473
S  1.451582 3.587726 9.025505
K_POINTS {automatic}
8 8 8 0 0 0
```
