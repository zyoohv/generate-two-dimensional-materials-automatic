MODULE find2d_com
   !
   USE kind
   !
   IMPLICIT NONE
   !
   ! basic variables of the system-----------------------------------
   !
   !
   ! basis vectors for lattice and reciprocal lattice from input
   REAL(KIND=DP), DIMENSION(3,3) :: cvec, bvec_c
   ! volume and wigner-seitz radius of lattice and reciprocal lattice
   REAL(KIND=DP) :: rvolume,gvolume,rradius,gradius
   !
   ! atoms position
   INTEGER :: nat
   INTEGER, ALLOCATABLE, DIMENSION(:) :: atom_type
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:,:) :: atom_tau
   !
   ! tolerance for lattice and reciprocal lattice
   REAL(KIND=DP) :: eps_scale, eps_r, eps_g
   !
   ! distance
   REAL(KIND=DP) :: dist_min, dist_a_min, dist_a_new, r_max
      ! minimal distance between crystal planes
      ! minimal distance between atoms in different crystal planes
      ! new distance between atoms in different crystal planes
      ! maximal magnitude of lattice vector grid
   !
   ! variables about crystal planes---------------------------------- 
   !
   INTEGER, PARAMETER :: gv_max_num=9261,gv_max_n1=10,gv_max_n2=10,&
                                                      gv_max_n3=10
   INTEGER :: gv_num
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:,:) :: gv_vec
      ! gv(1:3,fixed_num) three components on bvec_c...
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:) :: gv_len
   !
   ! variables about inner and intra layer basis vectors-------------
   !
   INTEGER, PARAMETER :: av_max_num=1331,av_max_n1=5,av_max_n2=5,&
                                                      av_max_n3=5
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:,:,:) :: avec
   !
ENDMODULE find2d_com
