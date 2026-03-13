!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D EULER EQUATION                  ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE DG_SETUP
IMPLICIT NONE

CALL LEGENDRE_POINTS

CALL DG_VPOINTS_BFUNCTION

CALL DG_BiBj_INTEGRAL_INVERSE

WRITE(*,*) "SATYA R13 SOLVER: DG SETUP IS DONE"

END SUBROUTINE