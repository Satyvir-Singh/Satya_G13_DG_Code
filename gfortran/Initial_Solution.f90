!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE INITIAL_SOLUTION(X,RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL)
USE VARIABLES_INFO
IMPLICIT NONE
DOUBLE PRECISION,INTENT(IN):: X
DOUBLE PRECISION,INTENT(OUT):: RHO_VAL,U_VAL, P_VAL, SIGMA_VAL, Q_VAL
DOUBLE PRECISION:: INITIAL_RHO, INITIAL_U, INITIAL_P, INITIAL_SIGMA, INITIAL_Q

!================================================================
! BOUNDARY AND INITIAL CONDITION
!================================================================
DOUBLE PRECISION :: DENSITY_L, VELOCITY_L, PRESSURE_L, TEMPERATURE_L,ENERGY_L, SIGMA_L, HEAT_L
DOUBLE PRECISION :: DENSITY_R, VELOCITY_R, PRESSURE_R, TEMPERATURE_R,ENERGY_R, SIGMA_R, HEAT_R


INITIAL_RHO = 0.0
INITIAL_U = 0.0
INITIAL_P = 0.0
INITIAL_SIGMA = 0.0
INITIAL_Q = 0.0
!******************************************************!
!***********     SOD SHOCK TUBE PROBLEM    ************!
!******************************************************!
IF(PROBLEM_SWITCH.EQ."SOD_SHOCK_TUBE")THEN 
    
DIAPHRAGM = 0.0 
    
!***** LEFT STATE                                  !***** RIGHT STATE
DENSITY_L  = 20.0                                  ;  DENSITY_R  = 1.0
VELOCITY_L = 0.0                                  ;  VELOCITY_R = 0.0
PRESSURE_L = 20.0                                  ;  PRESSURE_R = 1.0
SIGMA_L    = 0.0                                  ;  SIGMA_R = 0.0              
HEAT_L     = 0.0                                  ;  HEAT_R =0.0

IF(X .LE. DIAPHRAGM)THEN
INITIAL_RHO = DENSITY_L
INITIAL_U =   VELOCITY_L
INITIAL_P =   PRESSURE_L
INITIAL_SIGMA = SIGMA_L
INITIAL_Q =   HEAT_L
ELSE
INITIAL_RHO = DENSITY_R
INITIAL_U =   VELOCITY_R
INITIAL_P = PRESSURE_R 
INITIAL_SIGMA = SIGMA_R
INITIAL_Q =   HEAT_R
END IF

RHO_VAL   =   INITIAL_RHO  
U_VAL     =   INITIAL_U
P_VAL     =  INITIAL_P
SIGMA_VAL = INITIAL_SIGMA    
Q_VAL     = INITIAL_Q


!******************************************************!
!***********     LAX SHOCK TUBE PROBLEM    ************!
!******************************************************!
!ELSEIF(PROBLEM_SWITCH.EQ."LAX_SHOCK_TUBE")THEN

END IF
    
END SUBROUTINE    
    