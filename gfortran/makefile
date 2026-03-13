# Compiler and flags
FC     = gfortran
FFLAGS = -O2 -Wall -J.   # -J. so .mod are written/searched in current dir

# Directories
SRC_DIR     = .
DGSETUP_DIR = ./DG_Setup
DGSOLVER_DIR= ./DG_Solver

TARGET = dg_code

# Source files (explicit, to avoid picking up makefile/folders.txt)
SRC_TOP = \
Boundary_Condition.f90 \
CPU_Time.f90 \
DG_Calculator.f90 \
DG_Initialization.f90 \
DG_TimeStep.f90 \
Error_Calculation.f90 \
Grid_Generation.f90 \
Hyperbolicity_Region.f90 \
Initial_Solution.f90 \
Input_File.f90 \
Main_Program.f90 \
Positive_limiter.f90 \
Post_Process.f90 \
Post_Process_FlowField.f90 \
Post_Process_Hyperbolicity.f90 \
Post_Process_Time.f90 \
Preperation.f90 \
Problem_Definition.f90 \
Variables_Info.f90

SRC_DGSETUP = \
$(DGSETUP_DIR)/Basis_Function_Der.f90 \
$(DGSETUP_DIR)/Basis_Functions.f90 \
$(DGSETUP_DIR)/DG_BiBj_Integral_Inverse.f90 \
$(DGSETUP_DIR)/DG_Projection.f90 \
$(DGSETUP_DIR)/DG_Setup.f90 \
$(DGSETUP_DIR)/DG_VPoints_BFunction.f90 \
$(DGSETUP_DIR)/Legendre_Points.f90

SRC_DGSOLVER = \
$(DGSOLVER_DIR)/DG_Lu_Operator.f90 \
$(DGSOLVER_DIR)/Flux_Integral.f90 \
$(DGSOLVER_DIR)/Numerical_Flux.f90 \
$(DGSOLVER_DIR)/Physical_Flux.f90 \
$(DGSOLVER_DIR)/Primary_Equation_Solver.f90 \
$(DGSOLVER_DIR)/Rusanov_Scheme.f90 \
$(DGSOLVER_DIR)/Source_Integral.f90 \
$(DGSOLVER_DIR)/Updating_Equations.f90 \
$(DGSOLVER_DIR)/Volume_Integral.f90

SRC = $(SRC_TOP) $(SRC_DGSETUP) $(SRC_DGSOLVER)

# Object files
OBJ = $(SRC:.f90=.o)

# Default target
all: $(TARGET)

$(TARGET): $(OBJ)
	$(FC) $(FFLAGS) -o $@ $^

# Ensure module is compiled before users that USE it
Main_Program.o: Variables_Info.o
Boundary_Condition.o: Variables_Info.o
CPU_Time.o: Variables_Info.o
DG_Calculator.o: Variables_Info.o
DG_Initialization.o: Variables_Info.o
DG_TimeStep.o: Variables_Info.o
Error_Calculation.o: Variables_Info.o
Grid_Generation.o: Variables_Info.o
Hyperbolicity_Region.o: Variables_Info.o
Initial_Solution.o: Variables_Info.o
Input_File.o: Variables_Info.o
Positive_limiter.o: Variables_Info.o
Post_Process.o: Variables_Info.o
Post_Process_FlowField.o: Variables_Info.o
Post_Process_Hyperbolicity.o: Variables_Info.o
Post_Process_Time.o: Variables_Info.o
Preperation.o: Variables_Info.o
Problem_Definition.o: Variables_Info.o
$(DGSETUP_DIR)/%.o: Variables_Info.o
$(DGSOLVER_DIR)/%.o: Variables_Info.o

# Pattern rule for compiling any .f90 file to .o in-place
%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) *.mod ./Result_Flow/*.plt ./Result_Hyperbolicity/*.plt ./Result_Time/*.plt ./Time/*.txt $(TARGET)
