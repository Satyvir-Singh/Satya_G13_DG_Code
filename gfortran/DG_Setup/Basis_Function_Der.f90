!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D EULER EQUATION                  ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE SCALED_LEGENDRE_BASIS_DER (BASIS_ID,A,DBFUNCTION)
IMPLICIT NONE
INTEGER,INTENT(IN):: BASIS_ID
DOUBLE PRECISION,INTENT(IN):: A
DOUBLE PRECISION,INTENT(OUT):: DBFUNCTION

SELECT CASE(BASIS_ID)
         CASE(1)
 DBFUNCTION = 0.0
         CASE(2)
 DBFUNCTION = 1.0
         CASE(3)
 DBFUNCTION = 2.0*A
         CASE(4)
 DBFUNCTION = 3.0*A**2 - 3.0/5.0
         CASE(5)
 DBFUNCTION = 4.0*A**3 -12.0/7.0*A 
        CASE DEFAULT

 WRITE(*,*) 'WARNING,FOR THIS NUMBER, BASIS FUNCTIONS FOR UNIFORM MESHES ARE NOT DEFINED'
 STOP
 END SELECT 

END SUBROUTINE