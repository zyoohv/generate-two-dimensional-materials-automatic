MODULE kind
      IMPLICIT NONE
      INTEGER, PARAMETER :: DP = selected_real_kind(14,200)
      INTEGER, PARAMETER :: sgl = selected_real_kind(6,30)
      INTEGER, PARAMETER :: i4b = selected_int_kind(9)
      PUBLIC :: DP, sgl, i4b
ENDMODULE kind
