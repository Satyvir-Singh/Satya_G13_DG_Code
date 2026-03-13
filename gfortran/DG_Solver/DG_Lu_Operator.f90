!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE LU_OPERATOR
IMPLICIT NONE

!**** FLUXE CALCULATION  & FLUX SPLITING METHOD
      CALL FLUX_INTEGRAL

!**** BOUNDARY CONDITION IMPLEMENTATION      
      CALL BOUNDARY_CONDITION

!**** VOLUEM INTEGRATIONS INSIDE THE MASTER ELEMENTS
       CALL VOLUME_INTEGRAL

!**** SOURCE TERM INTEGRATIONS
      CALL SOURCE_TERM_INTEGRAL

!**** UPDATING THE VALUE OF THE PRIMARY DOFs 
      CALL UPDATING_EQUATIONS

END SUBROUTINE