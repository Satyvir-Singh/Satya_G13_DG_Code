!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE VOLUME_INTEGRAL
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: N, VP
INTEGER :: EQ, BF
DOUBLE PRECISION :: W0(MAX_EQ)
DOUBLE PRECISION :: FLUX_X(MAX_EQ)
DOUBLE PRECISION :: Uh
DOUBLE PRECISION :: DBI_DX_IN, INV_FLUX_DBi_Dxi

IF(DG_ORDER.GT.0)THEN
    
DO N = 1,NELEM_X   
VOLUME_INTEGRAL_CONSERVATIVE(:,:,N) = 0.0
  
DO VP = 1, MAX_VPOINTS    
DO EQ = 1, MAX_EQ  
     W0(EQ) = Uh( ai_CONSERVATIVE(EQ,:,N),BASIS_VPOINT_INSIDE(:,VP),MAX_BASIS ) 
END DO    

!******** PHYSICAL INVISCID FLUXES FOR THE INSIDE POINT
CALL PHYSICAL_FLUX(W0,FLUX_X)

  
DO BF = 1, MAX_BASIS
DO EQ = 1, MAX_EQ
    
DBI_DX_IN = BASIS_DER_VPOINT_INSIDE(BF,VP) 
INV_FLUX_DBi_Dxi= FLUX_X(EQ)*DBI_DX_IN                                                           
     
VOLUME_INTEGRAL_CONSERVATIVE(EQ,BF,N) = VOLUME_INTEGRAL_CONSERVATIVE(EQ,BF,N) + V_WEIGHT(VP)*INV_FLUX_DBi_Dxi*JACOBIAN(N)
                                                                                     
END DO
END DO   
END DO
  
END DO 

ELSE
VOLUME_INTEGRAL_CONSERVATIVE(:,:,:) = 0.0

END IF

END SUBROUTINE