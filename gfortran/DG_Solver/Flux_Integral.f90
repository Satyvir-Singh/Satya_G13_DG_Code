!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE FLUX_INTEGRAL
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: N, EQ, BF
DOUBLE PRECISION :: NORMAL
DOUBLE PRECISION :: W0_LEFT(MAX_EQ)
DOUBLE PRECISION :: W0_RIGHT(MAX_EQ)
DOUBLE PRECISION :: FLUX_SPLITTED(MAX_EQ)
DOUBLE PRECISION :: Bi_left, Bi_right
DOUBLE PRECISION :: Uh


DO N = 1,NELEM_X 
!===============================================================
!********** FACE=1 
!===============================================================       
NORMAL = -1.0
DO EQ = 1,MAX_EQ
  W0_LEFT(EQ)  = Uh( ai_CONSERVATIVE(EQ,:,N-1),BASIS_VP_FACE(2,:),MAX_BASIS )
  W0_RIGHT(EQ) = Uh( ai_CONSERVATIVE(EQ,:,N),BASIS_VP_FACE(1,:),MAX_BASIS )
END DO    

!**** INVISCID FLUX
CALL DG_NUMERICAL_FLUX(W0_LEFT,W0_RIGHT,FLUX_SPLITTED )

DO EQ=1,MAX_EQ
    FLUX_FACES_X(1,EQ) = FLUX_SPLITTED(EQ)*NORMAL
END DO
   
!===============================================================
!********** FACE=2   
!===============================================================       
NORMAL = 1.0
DO EQ = 1,MAX_EQ
  W0_LEFT(EQ)  = Uh( ai_CONSERVATIVE(EQ,:,N),BASIS_VP_FACE(2,:),MAX_BASIS )
  W0_RIGHT(EQ) = Uh( ai_CONSERVATIVE(EQ,:,N+1),BASIS_VP_FACE(1,:),MAX_BASIS )
END DO    

!**** INVISCID FLUX
CALL DG_NUMERICAL_FLUX(W0_LEFT,W0_RIGHT,FLUX_SPLITTED )

DO EQ=1,MAX_EQ
    FLUX_FACES_X(2,EQ) = FLUX_SPLITTED(EQ)*NORMAL
END DO
!===========================================================

DO BF=1,MAX_BASIS  
    Bi_left=BASIS_VP_FACE(1,BF)
    Bi_right=BASIS_VP_FACE(2,BF)
DO EQ=1,MAX_EQ
    SURFACE_INTEGRAL_CONSERVATIVE(EQ,BF,N) =  FLUX_FACES_X(1,EQ)*Bi_left + FLUX_FACES_X(2,EQ)*Bi_right  
                                                                                          
END DO
END DO

END DO

END SUBROUTINE