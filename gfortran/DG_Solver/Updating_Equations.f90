!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE UPDATING_EQUATIONS
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: N, EQ, BF

DO N = 1,NELEM_X
DO BF =1,MAX_BASIS
DO EQ = 1, MAX_EQ
        
Lu_CONSERVATIVE(EQ,BF,N) = (VOLUME_INTEGRAL_CONSERVATIVE(EQ,BF,N) - SURFACE_INTEGRAL_CONSERVATIVE(EQ,BF,N) &
                            + SOURCE_INTEGRAL_CONSERVATIVE(EQ,BF,N))*INTEGRAL_BiBj_INVERSE(BF,BF)            
    
END DO 
END DO
END DO

END SUBROUTINE