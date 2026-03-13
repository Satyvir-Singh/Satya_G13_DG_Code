!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE DG_POST_PROCESS
USE VARIABLES_INFO
IMPLICIT NONE

CALL POST_PROCESS_FLOW
!CALL POST_PROCESS_TIME
!CALL POST_PROCESS_Hyperbolicity
!CALL Hyperbolicity_Region

!===========================================================
!****** ENDING TIME COUNTER
FTIME=0
FINALtime=0
CALL CPU_TIME(FINALtime)
CALL TIME_DATE (FTIME)
!****** REPORTING TIME
CALL TIMEDIFF(STIME,FTIME,STARTtime,FINALtime)


END SUBROUTINE    