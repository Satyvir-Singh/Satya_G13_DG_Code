!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE SOURCE_TERM_INTEGRAL
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: N, VP
INTEGER :: EQ, BF
DOUBLE PRECISION :: Uh
DOUBLE PRECISION :: W0(MAX_EQ)
DOUBLE PRECISION :: PRODUCTION_TERM(MAX_EQ)
DOUBLE PRECISION :: RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL,T_VAL,ASOUND_VAL


DO N = 1,NELEM_X   
SOURCE_INTEGRAL_CONSERVATIVE(:,:,N) = 0.0
  
DO VP = 1, MAX_VPOINTS    
DO EQ = 1, MAX_EQ  
     W0(EQ) = Uh( ai_CONSERVATIVE(EQ,:,N),BASIS_VPOINT_INSIDE(:,VP),MAX_BASIS ) 
END DO    

!******** PRODUCTION TERMS FOR THE INSIDE POINT
CALL CONSERVATIVE_TO_PRIMITIVE(W0,RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL,T_VAL,ASOUND_VAL)

PRODUCTION_TERM(1) = 0.0
PRODUCTION_TERM(2) = 0.0
PRODUCTION_TERM(3) = 0.0
PRODUCTION_TERM(4) = -(4.0/5.0)*PRODUCTION_B*RHO_VAL*SIGMA_VAL
PRODUCTION_TERM(5) = -(8.0/5.0)*PRODUCTION_B*RHO_VAL*((2.0/3.0)*Q_VAL + SIGMA_VAL*U_VAL)

DO BF = 1, MAX_BASIS
DO EQ = 1, MAX_EQ                                                         
     
SOURCE_INTEGRAL_CONSERVATIVE(EQ,BF,N) = SOURCE_INTEGRAL_CONSERVATIVE(EQ,BF,N) + &
                                        V_WEIGHT(VP)*PRODUCTION_TERM(EQ)*BASIS_VPOINT_INSIDE(BF,VP)*JACOBIAN(N)
END DO
END DO   
END DO
  
END DO 


END SUBROUTINE
    
    
    
    
