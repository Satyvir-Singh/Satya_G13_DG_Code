!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE PHYSICAL_FLUX(W0,Phy_FLUX_X)
USE VARIABLES_INFO
IMPLICIT NONE
DOUBLE PRECISION,INTENT(IN)  :: W0(MAX_EQ)
DOUBLE PRECISION,INTENT(OUT) :: Phy_FLUX_X(MAX_EQ)

DOUBLE PRECISION :: RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL,T_VAL,ASOUND_VAL
DOUBLE PRECISION :: INV_RHO

CALL CONSERVATIVE_TO_PRIMITIVE(W0,RHO_VAL,U_VAL,P_VAL,SIGMA_VAL,Q_VAL,T_VAL,ASOUND_VAL)

Phy_FLUX_X(1) = RHO_VAL*U_VAL
Phy_FLUX_X(2) = RHO_VAL*U_VAL*U_VAL + P_VAL + SIGMA_VAL
Phy_FLUX_X(3) = RHO_VAL*U_VAL**3 + 5.0*P_VAL*U_VAL + 2.0*SIGMA_VAL*U_VAL + 2.0*Q_VAL
Phy_FLUX_X(4) = RHO_VAL*U_VAL**3 + 3.0*P_VAL*U_VAL + 3.0*SIGMA_VAL*U_VAL + (6.0/5.0)*Q_VAL
Phy_FLUX_X(5) = RHO_VAL*U_VAL**4 + 8.0*P_VAL*U_VAL**2 + 5.0*SIGMA_VAL*U_VAL*U_VAL + &
                (32.0/5.0)*Q_VAL*U_VAL + (P_VAL/RHO_VAL)*(5.0*P_VAL + 7.0*SIGMA_VAL)

END SUBROUTINE