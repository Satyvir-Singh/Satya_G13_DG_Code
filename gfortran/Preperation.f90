!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE PREPARATION
USE VARIABLES_INFO
IMPLICIT NONE

!================================================================
! DOMAIN INFORMATION
!================================================================
ALLOCATE (NODE_POS(2,-2:NELEM_X+3))
ALLOCATE (DELTA_X(-2:NELEM_X+3))
ALLOCATE (CENTER(-2:NELEM_X+3))
ALLOCATE (JACOBIAN(-2:NELEM_X+3))
NODE_POS(:,:) =0.0
DELTA_X(:) =0.0
CENTER(:) =0.0
JACOBIAN(:) =0.0


!================================================================
!**** NUMBER OF QUADRATURE POINTS
!================================================================
ALLOCATE (V_POINT (MAX_VPOINTS) )
ALLOCATE (V_WEIGHT(MAX_VPOINTS) ) 
V_POINT(:)=0.0
V_WEIGHT(:)=0.0


!================================================================
! BASIS FUNCTIONS
!================================================================
ALLOCATE (BASIS_VPOINT_INSIDE(MAX_BASIS, MAX_VPOINTS) )
ALLOCATE (BASIS_VPOINT_CENTER(MAX_BASIS) )
ALLOCATE (BASIS_DER_VPOINT_INSIDE(MAX_BASIS,MAX_VPOINTS) )
ALLOCATE (BASIS_VP_FACE(2,MAX_BASIS) )
BASIS_VPOINT_INSIDE(:,:) = 0.0
BASIS_DER_VPOINT_INSIDE(:,:) = 0.0
BASIS_VP_FACE(:,:) = 0.0
BASIS_VPOINT_CENTER (:) =0.0

ALLOCATE( INTEGRAL_BiBj_INVERSE(MAX_BASIS,MAX_BASIS) )
INTEGRAL_BiBj_INVERSE(:,:) =0.0


!================================================================
! DG VARIABLES
!================================================================
ALLOCATE( ai_CONSERVATIVE(MAX_EQ,MAX_BASIS,-2:NELEM_X+3) )
ALLOCATE( ai_CONSERVATIVE_Old(MAX_EQ,MAX_BASIS,-2:NELEM_X+3))
ALLOCATE( Lu_CONSERVATIVE(MAX_EQ,MAX_BASIS,-2:NELEM_X+3))
ai_CONSERVATIVE(:,:,:) =0.0
ai_CONSERVATIVE_Old(:,:,:) =0.0
Lu_CONSERVATIVE(:,:,:) =0.0

ALLOCATE( ai_CONSERVATIVE_TVDSTEP(4,MAX_EQ,MAX_BASIS,-2:NELEM_X+3) )
ai_CONSERVATIVE_TVDSTEP(:,:,:,:) =0.0


ALLOCATE( VOLUME_INTEGRAL_CONSERVATIVE (MAX_EQ,MAX_BASIS,-2:NELEM_X+3)) 
ALLOCATE( SOURCE_INTEGRAL_CONSERVATIVE (MAX_EQ,MAX_BASIS,-2:NELEM_X+3)) 
ALLOCATE( SURFACE_INTEGRAL_CONSERVATIVE(MAX_EQ,MAX_BASIS,-2:NELEM_X+3)) 
VOLUME_INTEGRAL_CONSERVATIVE(:,:,:) =0.0
SOURCE_INTEGRAL_CONSERVATIVE(:,:,:) =0.0
SURFACE_INTEGRAL_CONSERVATIVE(:,:,:) =0.0

ALLOCATE( FLUX_FACES_X(2,MAX_EQ)) 
FLUX_FACES_X(:,:) =0.0


!================================================================
! STABILITY INFROMATION
!================================================================
ALLOCATE (DT(-2:NELEM_X+3))
DT(:) =0.0


!================================================================
! ERROR INFORMATION
!================================================================
ALLOCATE(L0_ERROR(MAX_EQ) )
ALLOCATE(L1_ERROR(MAX_EQ) )
ALLOCATE(L2_ERROR(MAX_EQ) )
L0_ERROR(:)=0.0
L1_ERROR(:)=0.0
L2_ERROR(:)=0.0



END SUBROUTINE