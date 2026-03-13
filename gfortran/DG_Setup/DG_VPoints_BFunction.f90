!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D EULER EQUATION                  ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE DG_VPOINTS_BFUNCTION
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: VP, BF
DOUBLE PRECISION :: A_VALUE, BF_VALUE

!========================================================
! BASIS VALUE AT CELL CENTER
!========================================================
A_VALUE = 0.0
DO BF = 1, MAX_BASIS
  CALL SCALED_LEGENDRE_BASIS(BF,A_VALUE,BF_VALUE)  
  BASIS_VPOINT_CENTER(BF) = BF_VALUE
END DO    

!========================================================
! BASIS VALUE INSIDE THE CELL FOR VOLUME INTEGRATION
!========================================================
DO VP = 1, MAX_VPOINTS
  A_VALUE = V_POINT(VP)
  
  DO BF = 1, MAX_BASIS
  CALL SCALED_LEGENDRE_BASIS(BF,A_VALUE,BF_VALUE)  
  BASIS_VPOINT_INSIDE(BF,VP) = BF_VALUE
  END DO    
END DO

!========================================================
!  BASIS DERIVATIVE VALUE INSIDE THE CELL FOR VOLUME INTEGRATION
!========================================================
DO VP = 1, MAX_VPOINTS
  A_VALUE = V_POINT(VP)
  
  DO BF = 1, MAX_BASIS
  CALL SCALED_LEGENDRE_BASIS_DER(BF,A_VALUE,BF_VALUE)  
  BASIS_DER_VPOINT_INSIDE(BF,VP) = BF_VALUE/JACOBIAN_VALUE
  END DO   
END DO

!========================================================
! BASIS VALUE FOR FLUX INTEGRATION
!========================================================
! LEFT_FACE =1
A_VALUE = -1.0
DO BF = 1,MAX_BASIS
CALL SCALED_LEGENDRE_BASIS(BF,A_VALUE,BF_VALUE)
BASIS_VP_FACE(1,BF) = BF_VALUE 
END DO

! RIGHT_FACE = 2
A_VALUE = 1.0
DO BF = 1,MAX_BASIS
CALL SCALED_LEGENDRE_BASIS(BF,A_VALUE,BF_VALUE)
BASIS_VP_FACE(2,BF) = BF_VALUE 
END DO


END SUBROUTINE