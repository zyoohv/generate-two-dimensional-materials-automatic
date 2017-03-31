SUBROUTINE layer_cryst(nn)
   !
   USE kind
   USE phy_const, ONLY : const_pi
   USE my_math
   USE find2d_com, ONLY : cvec, atom_type, atom_tau, dist_a_min, dist_a_new, &
                          gv_vec, avec, rvolume, nat
   !
   !---------------------------------------------------------------------------
   IMPLICIT NONE
   !
   INTEGER, INTENT(IN) :: nn
   REAL(KIND=DP), DIMENSION(3) :: a1,a2,a3, gv, dv
   ! a1,a2,a3 : layered basis vectors, i.e. avec(:,:,nn)
   ! gv : gvectors, i.e. gv_vec(:,nn) 
   ! dv : parallel to gv, magnitude is distance between layers
   !
   INTEGER :: cell_num, nat_layer    
   ! cell_num : number of unit cells in the cell defined by a1a2a3
   ! nat_layer : number of atoms in layer unit cell
   !
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:,:) :: at_tau
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:) :: at_posp
   INTEGER, ALLOCATABLE, DIMENSION(:)   :: at_typ
   INTEGER, ALLOCATABLE, DIMENSION(:) :: at_lay
   ! atom position in cell defined by a1,a2,a3
   ! atom position projected on dv
   ! atom type
   ! atom layer
   !
   REAL(KIND=DP), ALLOCATABLE, DIMENSION(:) :: layer_dist
   REAL(KIND=DP) :: max_dist
   INTEGER :: layer_num
   !
   INTEGER :: ii,jj,kk,ll,cnt   ! counters
   REAL(KIND=DP), DIMENSION(3) :: vtmp
   REAL(KIND=DP) :: prj1, prj2, prj3, ptmp
   !
   CHARACTER(LEN=30) :: nametmp
   !
   !---------------------------------------------------------------------------
   !

   !
   ! Initialize----------------------------------------------------------------
   !
   a1 = avec(:,1,nn)
   a2 = avec(:,2,nn)
   a3 = avec(:,3,nn)
   gv = gv_vec(:,nn)
   dv = gv/dot_prod(gv,gv)*2*const_pi 
   cell_num = nint(abs(dot_prod(a1,x_prod(a2,a3)))/rvolume)
   nat_layer = cell_num*nat
   ALLOCATE(at_tau(3,nat_layer))
   ALLOCATE(at_posp(nat_layer))
   ALLOCATE(at_typ(nat_layer))
   !
   ! generating new cell defined by a1,a2,a3 ----------------------------------
   !
   cnt = 1
   ii = 0
   jj = 0
   kk = 0
   !
   DO ! ii 
      DO ! jj
         DO ! kk
            !
            vtmp = ii*cvec(:,1) + jj*cvec(:,2) + kk*cvec(:,3)
            prj1 = dot_prod(vtmp,a1)/dot_prod(a1,a1)
            prj2 = dot_prod(vtmp,a1)/dot_prod(a1,a1)
            prj3 = dot_prod(vtmp,a1)/dot_prod(a1,a1)
            !
            IF ( prj1>=0.0 .AND. prj1<1.0 .AND. prj2>=0 .AND. prj2<1.0 .AND. &
                 prj3>=0.0 .AND. prj3<1.0 ) THEN
               !
               DO ll=1,nat
                  at_tau(:,(cnt-1)*nat + ll) = atom_tau(:,ll) + vtmp
                  at_typ((cnt-1)*nat + ll) = atom_type(ll)
               ENDDO
               cnt = cnt + 1
               !
            ENDIF
            !
            IF (cnt>=cell_num) EXIT
            kk = -kk
            IF (kk >= 0) kk=kk+1
         ENDDO ! kk
         !
         IF (cnt>=cell_num) EXIT
         jj = -jj
         IF (jj >= 0) jj=jj+1
      ENDDO ! jj
      !
      IF (cnt>=cell_num) EXIT
      ii = -ii
      IF (ii >= 0) ii = ii + 1
      !
   ENDDO ! ii
   !
   ! sort atoms in dv(gv) direction--------------------------------------------
   !
   IF (nat_layer>1) THEN
      DO ii=1,nat_layer-1
         DO jj=nat_layer, ii+1, -1
           !
           IF ( dot_prod(dv,at_tau(:,jj-1)) > dot_prod(dv,at_tau(:,jj)) ) THEN
              vtmp = at_tau(:,jj-1)
              at_tau(:,jj-1) = at_tau(:,jj)
              at_tau(:,jj) = vtmp
              !
              ll = at_typ(jj-1)
              at_typ(jj-1) = at_typ(jj)
              at_typ(jj) = ll
           ENDIF
           !
         ENDDO ! jj
         !
         at_posp(ii) = dot_prod(dv,at_tau(:,ii))/vect_len(dv)
      ENDDO ! ii
      at_posp(nat_layer) = dot_prod(dv,at_tau(:,nat_layer))/vect_len(dv)
   ELSE
      at_posp(1) = dot_prod(dv,at_tau(:,1))/vect_len(dv)
   ENDIF
   !
   ! move to one cell
   !
   DO WHILE( at_posp(nat_layer)-at_posp(1) > vect_len(dv) )
         !
         vtmp = at_tau(:,1) + a3
         ll = at_typ(1)
         ptmp = dot_prod(dv,vtmp)/vect_len(dv)
         !
         ii=2
         DO WHILE ( at_posp(ii)<ptmp ) 
            at_typ(ii-1) = at_typ(ii)
            at_posp(ii-1) = at_posp(ii)
            at_tau(:,ii-1) = at_tau(:,ii)
            ii = ii + 1
         ENDDO
         !
         ii = ii - 1
         at_typ(ii) = ll
         at_posp(ii) = ptmp
         at_tau(:,ii) = vtmp
         !
   ENDDO
   !
   ! find atom layers----------------------------------------------------------
   !
   ALLOCATE(at_lay(nat_layer))
   ALLOCATE(layer_dist(nat_layer))
   !
   cnt = 0
   DO ii=1,nat_layer
      IF (ii==1) THEN
         layer_dist(1) = at_posp(1) + vect_len(dv) - at_posp(nat_layer)
         !
      ELSE
         layer_dist(ii) = at_posp(ii) - at_posp(ii-1)
         !
      ENDIF
      !
      IF (layer_dist(ii)>=dist_a_min) cnt = cnt + 1
      at_lay(ii) = cnt
   ENDDO
   layer_num = cnt
   !
   ! output -------------------------------------------------------------------
   !
   WRITE(*,102) vect_len(dv)
   102 FORMAT(T5,"|dv|=",F9.4)
   !
   WRITE(*,100) layer_num
   100 FORMAT(T5,"There are ",I2," atom layers in an unit cell:")
   !
   IF (layer_num>=1) THEN
      WRITE(*,103) max_dist(nat_layer,layer_dist)
      103 FORMAT("!",T4, "Maximal distance between layers is ", F9.4)
   ENDIF
   !
   DO ii=1,nat_layer
      !
      WRITE(*,101) at_typ(ii), ii, at_tau(:,ii), at_posp(ii), at_lay(ii), layer_dist(ii)
      101 FORMAT( T8, 'type=', I3,', tau(', I3, ')=(', 3F9.4, &
           ' ), proj=', F9.4, ', layer=', I2, ', dist=', F9.4 )
      !
   ENDDO
   !
   ! new cell with larger layer-distance
   !
 IF (layer_num>0) THEN
   DO ii=1,nat_layer
      !
      ! if this atom is the bottom of a layer, enlarge the distance
      !
      IF (layer_dist(ii)>dist_a_min) THEN
         !
         DO jj=ii,nat_layer
            at_tau(:,jj) = at_tau(:,jj) + (dist_a_new-layer_dist(ii))/vect_len(dv)*dv
         ENDDO
         !
         a3 = a3 + (dist_a_new-layer_dist(ii))/vect_len(dv)*dv
         !
      ENDIF
   ENDDO
   !
   dv = dot_prod(a3,dv)/vect_len(dv)/vect_len(dv)*dv 
   !
   WRITE(*,120) 
   120 FORMAT(T5,"New cell with larger layer-distance")
   !
   WRITE(*,121) 1, a1
   WRITE(*,121) 2, a2
   WRITE(*,121) 3, a3
   121 FORMAT(T8,'a(',I1,')=(', 3ES12.4,' )')
   !
   DO ii=1,nat_layer
      at_posp(ii) = dot_prod(at_tau(:,ii),dv)/vect_len(dv)
   ENDDO
   !
   DO ii=1,nat_layer
      IF (ii==1) THEN
         WRITE(*,122) at_typ(ii), ii, at_tau(:,ii), at_posp(ii), &
             at_lay(ii), at_posp(1) + vect_len(dv) - at_posp(nat_layer)
         122 FORMAT( T8, 'type=', I3,', tau(', I3, ')=(', 3F9.4, &
              ' ), proj=', F9.4, ', layer=', I2, ', dist=', F9.4 )
      ELSE
         WRITE(*,122) at_typ(ii), ii, at_tau(:,ii), at_posp(ii), &
                          at_lay(ii), at_posp(ii) - at_posp(ii-1)
      ENDIF
      !
   ENDDO
   !
   ! make xsf
   !
   WRITE(nametmp,'(I3)') nn
   nametmp = "xsf.g"//trim(adjustl(nametmp))//".xsf"
   CALL make_xsf(a1,a2,a3,nat_layer,at_tau,at_typ,nametmp)
   !
 ENDIF

   DEALLOCATE(at_tau)
   DEALLOCATE(at_typ)
   DEALLOCATE(at_posp)
   DEALLOCATE(at_lay)
   DEALLOCATE(layer_dist)
   !
ENDSUBROUTINE

FUNCTION max_dist(n,dist)
   !
   USE kind
   !
   IMPLICIT NONE
   !
   REAL(KIND=DP) :: max_dist
   INTEGER, INTENT(IN) :: n
   REAL(KIND=DP), DIMENSION(n), INTENT(IN) :: dist
   !
   INTEGER :: ii
   !
   max_dist = dist(1)
   DO ii=2,n
      IF (dist(ii)>max_dist) max_dist = dist(ii)
   ENDDO
   !
ENDFUNCTION

SUBROUTINE make_xsf(a1,a2,a3,na,tau,typ,filname)
   !
   USE kind
   !
   REAL(KIND=DP), DIMENSION(3), INTENT(IN) :: a1,a2,a3
   INTEGER, INTENT(IN) :: na
   REAL(KIND=DP), DIMENSION(3,na), INTENT(IN) :: tau
   INTEGER, DIMENSION(na), INTENT(IN) :: typ
   CHARACTER(LEN=40), INTENT(IN) :: filname
   !
   INTEGER, PARAMETER :: fil=1234
   INTEGER :: ii
   !
   ii=index(filname,' ')
   OPEN(UNIT=fil, FILE=filname(1:ii-1), STATUS='REPLACE', ACTION='WRITE', POSITION='REWIND')
   !
   WRITE(fil,140)
   140 FORMAT("CRYSTAL",/,"PRIMVEC")
   !
   WRITE(fil,141) a1(:)
   WRITE(fil,141) a2(:)
   WRITE(fil,141) a3(:)
   141 FORMAT(T4,3F20.8) 
   !
   WRITE(fil,142)
   142 FORMAT("CONVVEC")
   !
   WRITE(fil,141) a1(:)
   WRITE(fil,141) a2(:)
   WRITE(fil,141) a3(:)
   !
   WRITE(fil,143)
   143 FORMAT("PRIMCOORD")
   WRITE(fil,144) na, 1
   144 FORMAT(I3,I3)
   !
   DO ii=1,na
      WRITE(fil,145) typ(ii), tau(:,ii)
      145 FORMAT(I3,3F20.8) 
   ENDDO
   !
   CLOSE(fil)
   !
ENDSUBROUTINE
