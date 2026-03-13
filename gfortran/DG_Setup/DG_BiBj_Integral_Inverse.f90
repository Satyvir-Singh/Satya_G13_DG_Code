!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D EULER EQUATION                  ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE DG_BiBj_INTEGRAL_INVERSE
USE VARIABLES_INFO
IMPLICIT NONE
INTEGER :: BF
DOUBLE PRECISION :: INV_JACOBIAN

INV_JACOBIAN = 1/JACOBIAN_VALUE

DO BF = 1,MAX_BASIS
         SELECT CASE(BF)
           CASE(1)
 INTEGRAL_BiBj_INVERSE(1,1)  = (1.0/2.0)*INV_JACOBIAN     
           CASE(2)
 INTEGRAL_BiBj_INVERSE(2,2)  = (3.0/2.0)*INV_JACOBIAN
           CASE(3)
 INTEGRAL_BiBj_INVERSE(3,3)  = (45.0/8.0)*INV_JACOBIAN 
           CASE(4)
 INTEGRAL_BiBj_INVERSE(4,4)  = (175.0/8.0)*INV_JACOBIAN    
           CASE(5)
 INTEGRAL_BiBj_INVERSE(5,5)  = (275625.0/3848.0)*INV_JACOBIAN
          CASE DEFAULT
WRITE(*,*) 'WARNING,FOR THIS NUMBER, BASIS FUNCTIONS FOR UNIFORM MESHES ARE NOT DEFINED'
 STOP
           END SELECT
END DO
      
END SUBROUTINE