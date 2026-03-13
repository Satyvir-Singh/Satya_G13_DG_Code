!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D EULER EQUATION                  ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE SCALED_LEGENDRE_BASIS(BASIS_ID,A,BFUNCTION)
IMPLICIT NONE
INTEGER,INTENT(IN):: BASIS_ID
DOUBLE PRECISION,INTENT(IN):: A
DOUBLE PRECISION,INTENT(OUT):: BFUNCTION

SELECT CASE(BASIS_ID)
         CASE(1)
 BFUNCTION = 1.0
         CASE(2)
 BFUNCTION = A
         CASE(3)
 BFUNCTION = A*A-1.0/3.0
         CASE(4)
 BFUNCTION = A**3 -3.0/5.0*A
         CASE(5)
 BFUNCTION = A**4 -6.0/7.0*A**2 + 3.0/35
        CASE DEFAULT

 WRITE(*,*) 'WARNING,FOR THIS NUMBER, BASIS FUNCTIONS FOR UNIFORM MESHES ARE NOT DEFINED'
 STOP
 END SELECT

END SUBROUTINE