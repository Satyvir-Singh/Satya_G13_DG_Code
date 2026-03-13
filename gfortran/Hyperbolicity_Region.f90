!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE Hyperbolicity_Region
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: I, EQ
DOUBLE PRECISION :: Uh
DOUBLE PRECISION :: W0(MAX_EQ)
DOUBLE PRECISION :: RHO_VAL,U_VAL,E_VAL,P_VAL,T_VAL,ASOUND_VAL,MACH_VAL, SIGMA_VAL,Q_VAL
DOUBLE PRECISION :: NonDim_Sigma, NonDim_HeatFlux
DOUBLE PRECISION :: D_VAL, REGION_SIGMA, REGION_HEATFLUX

IF(MOD(ITERATION,NPRINT).EQ.0 .OR. FINAL_SOLUTION)THEN

WRITE(SUFFIX3,'(I2)')DG_ORDER
!-------------------------------------------------------------------------------------- TECPLOT ZONE NAME
IF(ITERATION.EQ.0)THEN
SUFFIX2="Initial"
OPEN(1,FILE=TRIM(DIRECTORY_1)//TRIM(FILENAME)//" -  " & 
//TRIM(PROBLEM_SWITCH)//" -  "//TRIM(SUFFIX2)//"-( P= "//TRIM(SUFFIX3)//" )" &
//TRIM(RESULTYPE) )
ELSE
WRITE(SUFFIX2,'(F6.3)')CURRENT_TIME
OPEN(1,FILE=TRIM(DIRECTORY_5)//TRIM(FILENAME)//" - Hyper_Region -  " &
//TRIM(PROBLEM_SWITCH)//" -  "//TRIM(SUFFIX2)//"-( P= "//TRIM(SUFFIX3)//" )" &
//TRIM(RESULTYPE) )
END IF

WRITE(1,'(A)') 'VARIABLES=  "Heatflux", "Sigma"'
WRITE(1,*) 'ZONE T="FLOOR", I=',NELEM_X,' F=POINT ' 

DO I = 1,NELEM_X
    
DO EQ = 1,MAX_EQ       
  W0(EQ) =  ai_CONSERVATIVE(EQ,1,I)  
END DO

CALL CONSERVATIVE_TO_PRIMITIVE (W0,RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL,T_VAL,ASOUND_VAL)
 
NonDim_Sigma = SIGMA_VAL/ (P_VAL + 1.0E-25)

NonDim_HeatFlux = Q_VAL/(P_VAL*sqrt(P_VAL/RHO_VAL)) 

D_VAL = SQRT(8541*NonDim_Sigma*NonDim_Sigma + 14553*NonDim_Sigma + 15957/2)

REGION_SIGMA = NonDim_Sigma

REGION_HEATFLUX = -(1.0/972)*sqrt(5.0/3.0)*(117 + 93*NonDim_Sigma - D_VAL) &
                   *sqrt(117 + 93*NonDim_Sigma + 2.0*D_VAL)

WRITE(1,1000) REGION_HEATFLUX, REGION_SIGMA


END DO

CLOSE(1) 
 
1000 FORMAT(2X,37E25.10) 

END IF 


END SUBROUTINE