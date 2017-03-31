MODULE my_math
 !
 USE kind
 !  
 CONTAINS
    FUNCTION dot_prod(a,b)
       REAL(KIND=DP) :: dot_prod
       REAL(KIND=DP), DIMENSION(:), INTENT(IN) :: a,b
       dot_prod = SUM(a*b)
       !dot_prod=a(1)*b(1)+a(2)*b(2)+a(3)*b(3)
    ENDFUNCTION dot_prod
    !
    FUNCTION x_prod(a,b)
       REAL(KIND=DP), DIMENSION(3) :: x_prod
       REAL(KIND=DP), DIMENSION(3), INTENT(IN) :: a,b
       x_prod(1)=a(2)*b(3)-a(3)*b(2) 
       x_prod(2)=a(3)*b(1)-a(1)*b(3) 
       x_prod(3)=a(1)*b(2)-a(2)*b(1) 
    ENDFUNCTION x_prod
    !
    FUNCTION mix_prod(a,b,c)
       REAL(KIND=DP) :: mix_prod
       REAL(KIND=DP), DIMENSION(3), INTENT(IN) :: a,b,c
       mix_prod=dot_prod(a,x_prod(b,c))
    ENDFUNCTION mix_prod
    !
    FUNCTION vect_len(a)
       REAL(KIND=DP) :: vect_len
       REAL(KIND=DP), DIMENSION(3), INTENT(IN) :: a
       vect_len = SQRT(SUM(a*a))
    ENDFUNCTION
    !
ENDMODULE my_math
