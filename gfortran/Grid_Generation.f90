!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE GRID_GENERATION
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: I

!***********************************!
!********   GRID GENERATION
!***********************************!
DOMAIN_SIZE = ABS(X_MAX - X_MIN)
UNIFORM_SPILITER=DOMAIN_SIZE/FLOAT(NELEM_X)
MID_LINE = 0.5*DOMAIN_SIZE

!----> REAL CELLS
DO I=-2,NELEM_X+3
   NODE_POS(1,I)=X_MIN+(I-1)*UNIFORM_SPILITER
   NODE_POS(2,I)=X_MIN+(I)*UNIFORM_SPILITER
   DELTA_X(I)=NODE_POS(2,I)-NODE_POS(1,I)
   CENTER(I)=(NODE_POS(2,I)+NODE_POS(1,I))/2.0
   JACOBIAN(I)= DELTA_X(I)/2.0
   JACOBIAN_VALUE =JACOBIAN(I) 
END DO

!================================================================
! PLOTTING OF THE MESH FILE
!================================================================
OPEN(2,FILE=TRIM(DIRECTORY_1)//"1D MESH"//TRIM(RESULTYPE) )
WRITE(2,'(A)')'VARIABLES = "X"'
WRITE(2,*)'ZONE T="FLOOR", I=',NELEM_X,' F=POINT ' 

DO I = 1,NELEM_X    
    WRITE(2,444) CENTER(I)
END DO 

CLOSE(2)
444 FORMAT(2X,37E25.10) 


WRITE(*,*) "SATYA R13 SOLVER: 1D-MESH IS GENERATED."

END SUBROUTINE