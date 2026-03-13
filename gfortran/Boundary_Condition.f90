!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE BOUNDARY_CONDITION
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER ::EQ,VP,BF

DO BF=1,MAX_BASIS
!    ai_CONSERVATIVE(1,BF,0) = ai_CONSERVATIVE(1,BF,0)
!    ai_CONSERVATIVE(1,BF,NELEM_X) = ai_CONSERVATIVE(1,BF,NELEM_X)
    ai_CONSERVATIVE(1,BF,0) = ai_CONSERVATIVE(1,BF,1)
    ai_CONSERVATIVE(1,BF,NELEM_X) = ai_CONSERVATIVE(1,BF,NELEM_X-1)
END DO

END SUBROUTINE