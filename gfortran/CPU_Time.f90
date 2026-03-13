!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE CPU_TIME_COST
USE VARIABLES_INFO
IMPLICIT NONE

!****** START TIME COUNTER
STARTtime=0
STIME=0
CALL CPU_TIME(STARTtime)
CALL TIME_DATE (STIME)   

END SUBROUTINE

!=============================================================+++++++

SUBROUTINE TIME_DATE (values)
CHARACTER(8)  :: date
CHARACTER(100) :: time
CHARACTER(5)  :: zone
INTEGER,DIMENSION(8) :: values
CALL DATE_AND_TIME(date,time,zone,values)
CALL DATE_AND_TIME(DATE=date,ZONE=zone)
CALL DATE_AND_TIME(TIME=time)
CALL DATE_AND_TIME(VALUES=values)
END SUBROUTINE

!===================================================================!
!==============                TIEM TABLE           ================!
!===================================================================!

SUBROUTINE TIMEDIFF(value1,value2,CP1,CP2)
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER:: value1(8),value2(8)
INTEGER:: diff(8)
DOUBLE PRECISION:: START,FINISH,DIFFRENCE
DOUBLE PRECISION:: CP1,CP2,CPU
LOGICAL :: PRINT_IT   

WRITE(SUFFIX3,'(I2)')DG_ORDER

IF(MOD(ITERATION,NPRINT).EQ.0 ) THEN
PRINT_IT=.TRUE.

ELSE
PRINT_IT=.FALSE.
END IF

IF( PRINT_IT .OR. ITERATION.EQ.0 )THEN

OPEN(100,FILE=TRIM(DIRECTORY_3)//"(P="//TRIM(SUFFIX3)//") -"//" (COMPUTATIONAL COST)"//TRIM(SUFFIX1) )

START= VALUE1(5)*60**2+VALUE1(6)*60+VALUE1(7)+VALUE1(8)*0.001
FINISH= VALUE2(5)*60**2+VALUE2(6)*60+VALUE2(7)+VALUE2(8)*.001
DIFFRENCE=(value2(2)-value1(2))*30*24*60**2+(value2(3)-value1(3))*24*60**2+(VALUE2(5)-VALUE1(5))*60**2+ &
          (VALUE2(6)-VALUE1(6))*60+(VALUE2(7)-VALUE1(7))+(VALUE2(8)-VALUE1(8))*0.001

CPU=CP2-CP1

WRITE(100,*)
WRITE(100,'(A)')'================================================================================='
WRITE(100,'(A)')'==========                 DG COMPUTATIONAL COST TABLE               ============'
WRITE(100,'(A)')'================================================================================='
WRITE(100,*)
WRITE(100,*)"========================================================================"
WRITE(100,*)"==== COMPUTATIONAL COST (in Second) ===="
WRITE(100,*)"========================================================================"
WRITE(100,20134)DIFFRENCE
WRITE(100,20141)CPU
WRITE(100,*)"========================================================================"
WRITE(100,*)"==== COMPUTATIONAL COST (in HOUR)   ===="
WRITE(100,*)"========================================================================"
WRITE(100,*)(value2(3)-value1(3))," Day(s) , ",(value2(5)-value1(5))," Hour(s) , "
WRITE(100,*)(value2(6)-value1(6))," Minute(s) , ",(value2(7)-value1(7))+(value2(8)-value1(8))*0.001," Second(s) "
WRITE(100,*)
WRITE(100,'(a)')"================================================================================"
WRITE(100,*)"==== SIMULATION IDENTITY            ===="
WRITE(100,'(a)')"================================================================================"
WRITE(100,*)
WRITE(100,20137)
WRITE(100,20138)
WRITE(100,20131)value1(1),value1(2),value1(3)
WRITE(100,20136)
WRITE(100,20133)value1(5),value1(6),value1(7),value1(8)
WRITE(100,2014)
WRITE(100,20137)
WRITE(100,20135)'================================================================================'
WRITE(100,*)
WRITE(100,20135)'================================================================================'
WRITE(100,20137)
WRITE(100,20139)
WRITE(100,20131)value2(1),value2(2),value2(3)
WRITE(100,20136)
WRITE(100,20133)value2(5),value2(6),value2(7),value2(8)
WRITE(100,2014)
WRITE(100,20137)
WRITE(100,20135)'================================================================================'
WRITE(100,*)


20131 FORMAT (' #####',5X,'YEAR: ',I5,2X,' MONTH:',I5,' DAY:',I5,30X,'#####')

20132 FORMAT (' HOURS: ',I8,5X,' MINUTES:',I8,5X,' SECOND:', I8,5X,'MILISECONDS:',I8,5X)

20133 FORMAT(' ####',6X,'TIME: ',I3,':',I3,':',I4,'.',I8, '(MiliSecond)',27X,'####')

20134 FORMAT(' TOTAL TIME (Sec): ',F28.8,5X)

20135 FORMAT(A81)

20136 FORMAT(' ###',74X,'###')

20137 FORMAT(' #########',62X,'#########')

20138 FORMAT(' #######',16X,'THIS SIMULATION WAS STARTED',23X,'#######')

20139 FORMAT(' #######',16X,'THIS SIMULATION WAS FINISHED',22X,'#######')

2014  FORMAT(' #######',66X,'#######')

20141 FORMAT(' CPU TIME (Sec): ',F28.8,5X)

CLOSE(100)

END IF

END SUBROUTINE 