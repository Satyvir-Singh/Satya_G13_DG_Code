!*********************************************************!
!*****        DISCONTINUOUS GALERKIN SOLVER       ********!
!*****                  FOR                        *******!
!*****             1D R13-EQUATIONS                   ****!
!*****                 *******                     *******!
!*****         DEVELOPER:   SATYVIR SINGH          *******!
!*********************************************************!
    
SUBROUTINE POSITIVITY_LIMITER
USE VARIABLES_INFO
IMPLICIT NONE

INTEGER :: N,EQ,VP,BF,FACE,VP1,FACE1
DOUBLE PRECISION:: W0(MAX_EQ),WVP(MAX_EQ),XI(2),CENTER0
DOUBLE PRECISION:: ebsilon_0=1.e-13
DOUBLE PRECISION:: ebsilon_min
DOUBLE PRECISION:: rho_min
DOUBLE PRECISION:: rho_avg
DOUBLE PRECISION:: RHO_HIGH
DOUBLE PRECISION:: RHO_VPS,RHOU_VPS,RHOE_VPS,PRESSURE_VPS,U_VPS
DOUBLE PRECISION:: p_avg
DOUBLE PRECISION:: p_HIGH
DOUBLE PRECISION:: p_s
DOUBLE PRECISION:: THETA0
DOUBLE PRECISION:: THETA1
DOUBLE PRECISION:: THETA2
DOUBLE PRECISION:: t_alpha
DOUBLE PRECISION:: t_min
DOUBLE PRECISION:: t_1
DOUBLE PRECISION:: t_0
DOUBLE PRECISION:: U_AVG,E_AVG
INTEGER ::Ti
DOUBLE PRECISION:: LIMITED_MODE
DOUBLE PRECISION:: RHO_VAL,P_VAL
DOUBLE PRECISION:: Uh

IF(POSITIVE_LIMITER_SWITCH.EQ."ENABLE")THEN
IF(DG_ORDER.GT.0)THEN

DO N=1,NELEM_X
t_alpha=0.0
ebsilon_min=0.0
LIMITED_MODE=0.0
RHO_HIGH=0.0
p_HIGH=0.0
p_s=0.0

!*** RESET DATA 
XI(1)=-1.0
XI(2)=1.0
THETA0=1.0      
THETA1=1.0
THETA2=1.0
rho_min=1.E20
t_min=1.E20

rho_avg = ai_CONSERVATIVE(1,1,N)
U_AVG = ai_CONSERVATIVE(2,1,N)/rho_avg
E_AVG = ai_CONSERVATIVE(3,1,N)/rho_avg
p_avg = (1.0/3.0)*(ai_CONSERVATIVE(3,1,N) - rho_avg*U_AVG*U_AVG)


IF(rho_avg<0.0.OR.p_avg<0.0)THEN
PRINT*,'CELL NUMBER ',N
PRINT*,"AVERAGE DENSITY/ PRESSURE BECAME NEGATIVE!"
PRINT*,"TIME STEP ",DT(N)
PRINT*,'CFL NUMBER ',CFL_NUMBER
PRINT*,'ITERATION ',ITERATION
STOP

ELSE

!-----------------------------> AVERAGES Q_bar
DO EQ=1,MAX_EQ
   W0(EQ)=ai_CONSERVATIVE(EQ,1,N)
END DO

!========================================================================================!
!====                        DENSITY POSITIVITY PRESERVING                           ====!
!========================================================================================!
!*** WE WOULD CHECK ALL QUADRATURE POINTS ON THE ELEMENT EDGES AND INSIDE THE VOLUME AS WELL AS CENTER OF ELEMENTS

!================================================================> SEARCH ALL DESIRED POINTS
!*** CENTER
RHO_VPS = Uh( ai_CONSERVATIVE(1,:,N),BASIS_VPOINT_CENTER,MAX_BASIS)
rho_min=MIN(rho_min,RHO_VPS)

!*** FACES
DO FACE=1,2
RHO_VPS = Uh( ai_CONSERVATIVE(1,:,N),BASIS_VP_FACE(FACE,:),MAX_BASIS)
rho_min=MIN(rho_min,RHO_VPS)
END DO
    
!*** VOLUME INTEGRALS 
DO VP=1,MAX_VPOINTS
RHO_VPS = Uh( ai_CONSERVATIVE(1,:,N),BASIS_VPOINT_INSIDE(:,VP),MAX_BASIS)
rho_min=MIN(rho_min,RHO_VPS)
END DO
    
    
!*** SECOND: DEFINE EBSILON
ebsilon_min=MIN(ebsilon_0,rho_avg,p_avg)

!**** CHECK DENSITY POSITIVITY
THETA0=(rho_avg-ebsilon_min)/(rho_avg-rho_min)
IF(THETA0.NE.1.0)THETA0=0.98*THETA0
THETA1=MIN( 1.0, THETA0)

IF(THETA1.NE.1.0)THEN
DO BF=2,MAX_BASIS
LIMITED_MODE=ai_CONSERVATIVE(1,BF,N)*theta1
ai_CONSERVATIVE(1,BF,N)=LIMITED_MODE
END DO 
END IF

!========================================================================================!
!====                        PRESSURE POSITIVITY PRESERVING                          ====!
!========================================================================================!
!**** FIRST: CALCULATION OF NEW Q^ WITH POSITIVE DENSITY

!*** CALCULATION OF PRESSURE AND Q_HAT WITH NEW POSITIVE DENSITY
!*** CENTER
RHO_VPS = Uh( ai_CONSERVATIVE(1,:,N),BASIS_VPOINT_CENTER,MAX_BASIS)
RHOU_VPS= Uh( ai_CONSERVATIVE(2,:,N),BASIS_VPOINT_CENTER,MAX_BASIS)
RHOE_VPS= Uh( ai_CONSERVATIVE(3,:,N),BASIS_VPOINT_CENTER,MAX_BASIS) 
      
    WVP(1)=RHO_VPS
    WVP(2)=RHOU_VPS
    WVP(3)=RHOE_VPS
    U_VPS = RHOU_VPS/ RHO_VPS
    PRESSURE_VPS = (1.0/3.0)*(WVP(3) - RHO_VPS*U_VPS*U_VPS)

    IF(PRESSURE_VPS.GE.ebsilon_min)THEN
      t_ALPHA=1.0
      t_min=MIN(t_min,t_ALPHA)
    ELSE
      t_ALPHA=(p_avg-ebsilon_min)/(p_avg-PRESSURE_VPS)
      t_min=MIN(t_min,t_ALPHA)
      IF(t_ALPHA<0.0)THEN
       PRINT*,"ERROR, t_alpha is negative in positivity limiter"
      END IF
    END IF

!*** FACES
DO FACE=1,2
    RHO_VPS = Uh(ai_CONSERVATIVE(1,:,N),BASIS_VP_FACE(FACE,:),MAX_BASIS)

    RHOU_VPS= Uh(ai_CONSERVATIVE(2,:,N),BASIS_VP_FACE(FACE,:),MAX_BASIS) 

    RHOE_VPS= Uh(ai_CONSERVATIVE(3,:,N),BASIS_VP_FACE(FACE,:),MAX_BASIS)

    WVP(1)=RHO_VPS
    WVP(2)=RHOU_VPS
    WVP(3)=RHOE_VPS
    U_VPS = RHOU_VPS/ RHO_VPS
    !PRESSURE_VPS= (GAMMA-1.0)*(RHOE_VPS-0.5*RHO_VPS*(U_VPS*U_VPS))
    PRESSURE_VPS = (1.0/3.0)*(WVP(3) - RHO_VPS*U_VPS*U_VPS)

    IF(PRESSURE_VPS.GE.ebsilon_min)THEN
      t_ALPHA=1.0
      t_min=MIN(t_min,t_ALPHA)
    ELSE
      t_ALPHA=(p_avg-ebsilon_min)/(p_avg-PRESSURE_VPS)
      t_min=MIN(t_min,t_ALPHA)
      IF(t_ALPHA<0.0)THEN
       PRINT*,"ERROR, t_alpha is negative in positivity limiter"
      END IF
    END IF
    END DO

!*** ALL QUADRATURE POINTS
DO VP=1,MAX_VPOINTS
    RHO_VPS = Uh( ai_CONSERVATIVE(1,:,N),BASIS_VPOINT_INSIDE(:,VP),MAX_BASIS)

    RHOU_VPS= Uh( ai_CONSERVATIVE(2,:,N),BASIS_VPOINT_INSIDE(:,VP),MAX_BASIS)

    RHOE_VPS = Uh( ai_CONSERVATIVE(3,:,N),BASIS_VPOINT_INSIDE(:,VP),MAX_BASIS)

    WVP(1)=RHO_VPS
    WVP(2)=RHOU_VPS
    WVP(3)=RHOE_VPS
    U_VPS = RHOU_VPS/ RHO_VPS
    !PRESSURE_VPS= (GAMMA-1.0)*(RHOE_VPS-0.5*RHO_VPS*(U_VPS*U_VPS))
    PRESSURE_VPS = (1.0/3.0)*(WVP(3) - RHO_VPS*U_VPS*U_VPS)
    
    IF(PRESSURE_VPS.GE.ebsilon_min)THEN
      t_ALPHA=1.0
      t_min=MIN(t_min,t_ALPHA)
    ELSE
      t_ALPHA=(p_avg-ebsilon_min)/(p_avg-PRESSURE_VPS)
      t_min=MIN(t_min,t_ALPHA)
      IF(t_ALPHA<0.0)THEN
       PRINT*,"ERROR, t_alpha is negative in positivity limiter"
      END IF
    END IF
END DO

    IF(t_min.NE.1.0)t_min=0.98*t_min

    !**** CHECK DENSITY POSITIVITY
    theta2=MIN(1.0,t_min)
    DO EQ=1,MAX_EQ
    DO BF=2,MAX_BASIS
        LIMITED_MODE=ai_CONSERVATIVE(EQ,BF,N)*theta2
        ai_CONSERVATIVE(EQ,BF,N)=LIMITED_MODE        
    END DO
    END DO

END IF
END DO

END IF
END IF

END SUBROUTINE

