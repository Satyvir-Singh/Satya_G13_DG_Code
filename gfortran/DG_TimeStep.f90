!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE DG_TIMESTEP
USE VARIABLES_INFO
IMPLICIT NONE

INTEGER :: N, EQ
DOUBLE PRECISION:: W0(MAX_EQ)
DOUBLE PRECISION:: CONVECTIVE_SPECTRAL_RADii
DOUBLE PRECISION:: RHO_VAL,U_VAL,P_VAL,T_VAL,ASOUND_VAL,MIU,SIGMA_VAL,Q_VAL



MINIMUM_DT = 1.0E+20

!********************* LOCAL TIME CALCULATION BASED ON AVERAGE VALUE
DO N=1,NELEM_X

DO EQ = 1,MAX_EQ       
     W0(EQ) =  ai_CONSERVATIVE(EQ,1,N)
END DO

!**************** PRIMITIVE DATA
CALL CONSERVATIVE_TO_PRIMITIVE(W0,RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL,T_VAL,ASOUND_VAL)

CONVECTIVE_SPECTRAL_RADii = ABS(U_VAL) + ASOUND_VAL

DT(N)=CFL_NUMBER*DELTA_X(N)/(CONVECTIVE_SPECTRAL_RADii)

MINIMUM_DT = MIN(MINIMUM_DT,DT(N))

END DO


DO N=1,NELEM_X
      DT(N) =  MINIMUM_DT
END DO

END SUBROUTINE