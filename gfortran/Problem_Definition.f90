!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE PROBLEM_DEFINITION
USE VARIABLES_INFO
IMPLICIT NONE

!******************************************************!
!***********     SOD SHOCK TUBE PROBLEM    ************!
!******************************************************!
IF(PROBLEM_SWITCH.EQ."SOD_SHOCK_TUBE")THEN

!X_MIN = -1.0
!X_MAX = 1.0
!DIAPHRAGM = 0.0 
!FINAL_TIME = 0.4


END IF    


END SUBROUTINE