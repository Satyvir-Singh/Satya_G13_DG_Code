!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D G13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
PROGRAM MAIN_PROGRAM
USE VARIABLES_INFO
IMPLICIT NONE

WRITE(*,*)"!*********************************************************!"
WRITE(*,*)"!*****        DISCONTINUOUS GALERKIN SOLVER       ********!"
WRITE(*,*)"!*****                  FOR                        *******!"
WRITE(*,*)"!*****             1D G13-EQUATIONS                   ****!"
WRITE(*,*)"!*****                 *******                     *******!"
WRITE(*,*)"!*****         DEVELOPER:   SATYVIR SINGH          *******!"
WRITE(*,*)"!*********************************************************!"
WRITE(*,*)

CALL INPUT_FILE

CALL PREPARATION

CALL GRID_GENERATION

CALL DG_SETUP

CALL CPU_TIME_COST

CALL DG_INITIALIZATION

CALL POSITIVITY_LIMITER

!====================================================================
DO WHILE (CURRENT_TIME.LE.FINAL_TIME) 
    
CALL DG_TIMESTEP

ITERATION = ITERATION + 1
CURRENT_TIME = CURRENT_TIME + MINIMUM_DT 

CALL PRIMARY_EQUATION_SOLVER

CALL POSITIVITY_LIMITER

CALL ERROR_CALCULATION

CALL DG_POST_PROCESS

!================================================
END DO   ! DO WHILE
!=================================================
    
FINAL_SOLUTION=.TRUE.

CALL DG_POST_PROCESS


END PROGRAM