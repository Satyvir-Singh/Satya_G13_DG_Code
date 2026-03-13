!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE PRIMARY_EQUATION_SOLVER
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: N,EQ,BF

!****************** SAVE OLD STEP
DO N = 1,NELEM_X
DO BF = 1, MAX_BASIS    
DO EQ = 1, MAX_EQ

     ai_CONSERVATIVE_Old(EQ,BF,N) = ai_CONSERVATIVE(EQ,BF,N)

END DO !---> EQ
END DO !----> BASIS
END DO !---> NELEM_X


IF(TEMPORAL_SCHEME_SWITCH.EQ."FORWARD_EULER")THEN
CALL LU_OPERATOR
DO N=1,NELEM_X
DO EQ=1,MAX_EQ
DO BF=1, MAX_BASIS
    ai_CONSERVATIVE(EQ,BF,N)= ai_CONSERVATIVE_Old(EQ,BF,N) + DT(N)*Lu_CONSERVATIVE(EQ,BF,N)
END DO
END DO
END DO
CALL POSITIVITY_LIMITER
!CALL DG__LIMITING_PROCESS

ELSEIF(TEMPORAL_SCHEME_SWITCH.EQ."TVD_3RD")THEN

!============================================================================================!
!============                       3RD-ORDER TVD-RUNG-KUTTA                    =============!
!============================================================================================!
!****************** FIRST STEP
CALL LU_OPERATOR
DO N=1,NELEM_X
DO EQ=1,MAX_EQ
DO BF=1,MAX_BASIS
    ai_CONSERVATIVE(EQ,BF,N)= ai_CONSERVATIVE_Old(EQ,BF,N) + DT(N)*Lu_CONSERVATIVE(EQ,BF,N)
END DO
END DO
END DO
CALL POSITIVITY_LIMITER
!CALL DG__LIMITING_PROCESS

!****************** SECOND STEP
CALL LU_OPERATOR
DO N=1,NELEM_X
DO EQ=1,MAX_EQ
DO BF=1, MAX_BASIS
   ai_CONSERVATIVE(EQ,BF,N)= 0.750*ai_CONSERVATIVE_Old(EQ,BF,N) + 0.25*ai_CONSERVATIVE(EQ,BF,N) &
   +0.25*DT(N)*Lu_CONSERVATIVE(EQ,BF,N)
END DO
END DO
END DO
CALL POSITIVITY_LIMITER
!CALL DG__LIMITING_PROCESS
!******** keep U(1) TO USE IN NEXT STEP

!****************** THIRD STEP
CALL LU_OPERATOR
DO N=1,NELEM_X
DO EQ=1,MAX_EQ
DO BF=1, MAX_BASIS
    ai_CONSERVATIVE(EQ,BF,N)= 1.0/3.0*ai_CONSERVATIVE_Old(EQ,BF,N) + 2.0/3.0*ai_CONSERVATIVE(EQ,BF,N) &
	+ 2.0/3.0*DT(N)*Lu_CONSERVATIVE(EQ,BF,N)
END DO
END DO
END DO
CALL POSITIVITY_LIMITER
!CALL DG__LIMITING_PROCESS
ELSE
WRITE(*,*)"ERROR, PROPER METHOD DOES NOT CHOSE FOR SOLVING ODE"
STOP
END IF

END SUBROUTINE
