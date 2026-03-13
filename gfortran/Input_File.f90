!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE INPUT_FILE
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: I
CHARACTER(LEN=40) :: DUMMY

!** GOVERNING EQUATION
MAX_EQ = 5

!================================================================
! FILE INFORMATION
!================================================================
DIRECTORY_1 = "RESULT_FLOW/"
DIRECTORY_2 = "INPUT/"
DIRECTORY_3 = "TIME/"
DIRECTORY_4 = "RESULT_TIME/"
DIRECTORY_5 = "Result_Hyperbolicity/"
INPUT_FILENAME = "INPUT_FILE"
FILENAME = "G13_Solution"
RESULTYPE = ".plt"
SUFFIX1 = ".txt"

!================================================================
! READ INPUT FILE INFORMATION
!================================================================
OPEN(1,FILE=TRIM(DIRECTORY_2)//TRIM(INPUT_FILENAME)//TRIM(SUFFIX1) )

DO I = 1, 6
READ(1,*) 
END DO

!******* COMPUTATIONAL DOMAIN INFROMATION 
READ(1,*) DUMMY, DUMMY, DUMMY, DUMMY, DUMMY, NELEM_X
READ(1,*) DUMMY, DUMMY, DUMMY, X_MIN
READ(1,*) DUMMY, DUMMY, DUMMY, X_MAX


!****** GOVERNING EQUATION
DO I = 1,2
READ(1,*) 
END DO
READ(1,*) DUMMY, DUMMY, DUMMY, GOV_EQUATION_SWITCH
READ(1,*) DUMMY, DUMMY, DUMMY, PROBLEM_SWITCH


!****** SOLVER INFROMATION
DO I = 1,2
READ(1,*) 
END DO
READ(1,*) DUMMY,DUMMY,DUMMY,DUMMY,DG_ORDER
READ(1,*) DUMMY,DUMMY,DUMMY,DUMMY,MAX_VPOINTS

MAX_BASIS = (DG_ORDER+1)

!****** STABILITY INFROMATION
DO I = 1,2
READ(1,*) 
END DO
READ(1,*) DUMMY, DUMMY, DUMMY, CFL_NUMBER
READ(1,*) DUMMY, DUMMY, DUMMY, MAX_ERROR_VAL
READ(1,*) DUMMY, DUMMY, DUMMY, FINAL_TIME
READ(1,*) DUMMY, DUMMY, DUMMY, NPRINT
READ(1,*) DUMMY, DUMMY, DUMMY,TEMPORAL_SCHEME_SWITCH
READ(1,*) DUMMY, DUMMY, DUMMY, DUMMY, INVISCID_FLUX_SWITCH
READ(1,*) DUMMY, DUMMY, DUMMY, POSITIVE_LIMITER_SWITCH

!****** GA INFORMATION
DO I = 1,2
READ(1,*) 
END DO
READ(1,*) DUMMY, DUMMY, GAMMA
READ(1,*) DUMMY, DUMMY, DUMMY, GASR
READ(1,*) DUMMY, DUMMY, DUMMY, PRODUCTION_B


CLOSE(1)

!CALL PROBLEM_DEFINITION

WRITE(*,*) "SATYA R13 SOLVER: INPUT FILE IS READ" 

END SUBROUTINE