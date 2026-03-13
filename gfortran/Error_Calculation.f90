!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE ERROR_CALCULATION
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER:: I, EQ, BF
DOUBLE PRECISION :: NEW_VAL(MAX_EQ)
DOUBLE PRECISION :: OLD_VAL(MAX_EQ)

L0_ERROR(:)=0.0
L1_ERROR(:)=0.0
L2_ERROR(:)=0.0

!=======================================================

DO I = 1,NELEM_X
    
DO BF = 1, MAX_BASIS 
DO EQ=1,MAX_EQ
   L2_ERROR(EQ) = L2_ERROR(EQ) + (ai_CONSERVATIVE(EQ,BF,I)-ai_CONSERVATIVE_Old(EQ,BF,I))**2  
  END DO
END DO

!=====> Infinity Norm Error
DO EQ=1,MAX_EQ
   NEW_VAL(EQ) = ai_CONSERVATIVE(EQ,1,I)
   OLD_VAL(EQ) = ai_CONSERVATIVE_Old(EQ,1,I)
   
   L0_ERROR(EQ) = MAX(0.0, ABS(NEW_VAL(EQ)-OLD_VAL(EQ)),L0_ERROR(EQ))
       
END DO
END DO

MAX_RESIDUAL=MAXVAL(L0_ERROR)
CURRENT_ERROR=ABS(MAX_RESIDUAL)

L2_ERROR(:)=SQRT(L2_ERROR(:))/NELEM_X
L2_ERROR(:)=L2_ERROR(:) 
MAX_RESIDUAL=MAX_RESIDUAL   
   
IF(MOD(ITERATION,NPRINT).EQ.0)THEN
WRITE(*,'(A,I7,X,2(2X,A,ES17.10),2X,A,ES14.4)') &
    'ITERATION :',ITERATION, &
    'MAX_ERROR(L_infinity):',MAX_RESIDUAL, &
    'MAX_ERROR (L_2):',L2_ERROR(1), &
    "TIME:",CURRENT_TIME
END IF


END SUBROUTINE