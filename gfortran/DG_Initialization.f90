!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE DG_INITIALIZATION
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER ::I,J,VP1, VP2
INTEGER ::EQ, BF

DOUBLE PRECISION,ALLOCATABLE,DIMENSION(:,:) :: Uhi
DOUBLE PRECISION,ALLOCATABLE,DIMENSION(:,:) :: DOFh
DOUBLE PRECISION :: W0(MAX_EQ)
DOUBLE PRECISION :: Uh
DOUBLE PRECISION :: RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL


ALLOCATE(Uhi(MAX_EQ,MAX_VPOINTS))
ALLOCATE(DOFh(MAX_EQ,MAX_BASIS))
Uhi = 0.0
DOFh =0.0

!==========================================================================
!RESET TIME STEP
!==========================================================================
ITERATION = 0
CURRENT_TIME = 0.0
!==========================================================================
!========================================================================== 

DO I=-2,NELEM_X+3
    
CALL INITIAL_SOLUTION(NODE_POS(2,I),RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL)

Uhi(1,:) = RHO_VAL
Uhi(2,:) = RHO_VAL*U_VAL
Uhi(3,:) = RHO_VAL*U_VAL*U_VAL + 3.0*P_VAL
Uhi(4,:) = RHO_VAL*U_VAL*U_VAL + P_VAL + SIGMA_VAL 
Uhi(5,:) = RHO_VAL*U_VAL**3 + 5.0*P_VAL*U_VAL + 2.0*SIGMA_VAL*U_VAL + 2.0*Q_VAL

DO EQ =1, MAX_EQ

CALL DG_DOF_Uh_FULL(JACOBIAN_VALUE,Uhi(EQ,:),BASIS_VPOINT_INSIDE,V_WEIGHT,MAX_VPOINTS,DOFh(EQ,:))

DO BF = 1,MAX_BASIS
      ai_CONSERVATIVE(EQ,BF,I)  =  DOFh(EQ,BF)              
END DO  !---> BF

!******************** OTHERS COFFIECENTS ARE CONSIDER ZERO IN INITIALIZATION
IF(DG_ORDER.GT.0)THEN
   ai_CONSERVATIVE(:,2:MAX_BASIS,I) = 0.0 
END IF

END DO  !---> EQUATION
END DO  ! NELEM_X


!***********************************!
!********   BOUNDARY CONDITION
!***********************************!
CALL BOUNDARY_CONDITION

CALL DG_POST_PROCESS

WRITE(*,*) 'SATYA R13 SOLVER: DG PROGRAM IS INITIALIZED.'
WRITE(*,*)  

DEALLOCATE(Uhi)
DEALLOCATE(DOFh)

END SUBROUTINE