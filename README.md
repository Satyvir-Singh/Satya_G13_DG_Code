# Satya\_G13\_DG\_Code

A **1D Modal Discontinuous Galerkin (DG) solver for Grad's 13-moment (G13) equations**, written in Fortran 90. The code simulates non-equilibrium gas flows in the continuum-rarefied regime and accompanies the following publication:

> **Satyvir Singh, Hang Song & Manuel Torrilhon**,
> *"Modal Discontinuous Galerkin Simulations for Grad's 13 Moment Equations: Application to Riemann Problems in the Continuum-Rarefied Flow Regime"*,
> *Journal of Computational and Theoretical Transport*, Vol. 53, No. 6, pp. 398–422, 2024.
> DOI: [10.1080/23324309.2024.2342947](https://doi.org/10.1080/23324309.2024.2342947)

---

## Overview

Classical fluid dynamics (Navier–Stokes equations) breaks down when the gas is sufficiently rarefied — i.e., when the **Knudsen number** Kn = λ/L (mean free path / characteristic length) is not negligibly small. Grad's 13-moment (G13) system extends the hydrodynamic description by evolving five fields: density ρ, velocity u, pressure p, deviatoric stress σ, and heat flux q. This gives a richer description of non-equilibrium effects than Navier–Stokes while remaining computationally less expensive than full kinetic (Boltzmann) solvers.

The G13 system is written in conservation form:

```
∂U/∂t  +  ∂F(U)/∂x  =  P(U)
```

where the state vector is **U** = (ρ, ρu, ½ρu² + 3/2 p, stress-related, heat-flux-related)ᵀ, **F** is the physical flux vector, and **P** contains relaxation production terms scaled by 1/Kn. The code solves this system on a 1D domain using a high-order DG method and is benchmarked on three canonical Riemann problems spanning a wide range of Knudsen numbers.

A key physical result demonstrated by the code is that the G13 system is **only conditionally hyperbolic**: for sufficiently large pressure ratios or Knudsen numbers, the stress–heat-flux state (σ, q) can exit the hyperbolicity region, causing wave speeds to become complex and the solution to break down. The code tracks and outputs this hyperbolicity region to identify these failure modes.

---

## Numerical Method

### Modal DG Discretization

The spatial discretization is based on a **hierarchical modal basis** built from scaled Legendre polynomials on each element Ω_k = [x_{k-½}, x_{k+½}]:

```
φ_i(ξ)  =  [2^i (i!)²/(2i)!]  P_i(ξ),     ξ ∈ [−1, 1]
```

where P_i is the Legendre polynomial of degree i. The approximate solution in each cell is represented as:

```
U_h(x,t)|_{Ω_k}  =  Σ_{i=0}^{ℓ}  û_i^k(t) φ_i(ξ(x))
```

with **ℓ** being the polynomial degree (DG order). Multiplying by test functions and integrating by parts over each element yields the semi-discrete DG weak form. The mass matrix (∫ φ_i φ_j dx) is diagonal due to the orthogonality of the Legendre basis, which makes the scheme particularly efficient.

### Numerical Flux

At element interfaces, the **Local Lax–Friedrichs (LLF) / Rusanov flux** is used:

```
F̂(U⁻, U⁺) = ½ [F(U⁻) + F(U⁺)] − ½ C_max (U⁺ − U⁻)
```

The maximum characteristic speed for G13 is C_max = **1.6503** (in normalized units), determined from the eigenstructure of the G13 flux Jacobian.

### Quadrature

Volume integrals are evaluated with **Gauss–Legendre quadrature**, exact for polynomials of degree up to 2ℓ+1. Boundary (face) evaluations use the Gauss–Legendre points at ξ = ±1.

### Time Integration

Time advancement uses the **3rd-order Strong Stability Preserving (SSP) Runge–Kutta** scheme (Shu–Osher form):

```
U⁽¹⁾  =  Uⁿ  +  Δt L(Uⁿ)
U⁽²⁾  =  ¾ Uⁿ  +  ¼ U⁽¹⁾  +  ¼ Δt L(U⁽¹⁾)
U^{n+1}  =  ⅓ Uⁿ  +  ⅔ U⁽²⁾  +  ⅔ Δt L(U⁽²⁾)
```

where L(U) is the DG spatial operator (flux divergence plus source). The time step Δt is determined by a CFL condition set in the input file.

### Positivity-Preserving Limiter

To maintain physical realizability (positive density and pressure), the **Zhang–Shu positivity-preserving limiter** is applied after each Runge–Kutta stage. This limiter rescales the higher-mode DOFs within each cell while preserving the cell-average, ensuring ρ > 0 and p > 0 throughout the simulation.

### Hyperbolicity Enforcement

A dedicated `Hyperbolicity_Region` module monitors the normalized stress and heat flux (σ̄, q̄) against the analytically derived hyperbolicity boundary of the G13 system. This allows identification of regimes where the G13 model loses physical validity and motivates regularization (R13 equations).

### Convergence

The scheme achieves **(ℓ+1)-th order** spatial convergence in L² for smooth solutions, confirmed numerically for polynomial orders P1 through P4 (2nd to 5th order).

---

## Repository Structure

```
Satya_G13_DG_Code/
└── gfortran/
    ├── makefile                        # Build system (gfortran)
    ├── Main_Program.f90                # Entry point: controls the time-loop
    ├── Variables_Info.f90              # Global variables and module definitions
    ├── Input_File.f90                  # Reads parameters from Input/INPUT_FILE.txt
    ├── Preperation.f90                 # Memory allocation and preprocessing
    ├── Grid_Generation.f90             # Uniform 1D mesh construction
    ├── Initial_Solution.f90            # Sets initial conditions (Riemann data)
    ├── Boundary_Condition.f90          # Inflow/outflow boundary conditions
    ├── DG_Initialization.f90           # Projects ICs onto DG basis
    ├── DG_TimeStep.f90                 # CFL-based time step computation
    ├── DG_Calculator.f90               # Assembles DG residuals
    ├── Positive_limiter.f90            # Zhang–Shu positivity-preserving limiter
    ├── Hyperbolicity_Region.f90        # Monitors G13 hyperbolicity condition
    ├── Error_Calculation.f90           # L² / L∞ error norms
    ├── CPU_Time.f90                    # Wall-clock timing utilities
    ├── Post_Process.f90                # Output dispatch
    ├── Post_Process_FlowField.f90      # Writes flow field to .plt (Tecplot)
    ├── Post_Process_Hyperbolicity.f90  # Writes hyperbolicity data
    ├── Post_Process_Time.f90           # Writes time history data
    ├── Problem_Definition.f90          # Problem-specific parameters
    ├── Input/
    │   └── INPUT_FILE.txt              # Simulation input parameters
    ├── DG_Setup/
    │   ├── Basis_Functions.f90         # Scaled Legendre basis evaluation
    │   ├── Basis_Function_Der.f90      # Basis function derivatives
    │   ├── Legendre_Points.f90         # Gauss–Legendre quadrature nodes & weights
    │   ├── DG_BiBj_Integral_Inverse.f90# Mass matrix inversion
    │   ├── DG_Projection.f90           # L² projection of ICs onto DG space
    │   ├── DG_Setup.f90                # Orchestrates DG setup
    │   └── DG_VPoints_BFunction.f90    # Basis functions at quadrature points
    ├── DG_Solver/
    │   ├── Primary_Equation_Solver.f90 # SSP-RK3 time integration
    │   ├── DG_Lu_Operator.f90          # DG spatial operator L(U)
    │   ├── Volume_Integral.f90         # Volume term assembly
    │   ├── Flux_Integral.f90           # Interface flux term assembly
    │   ├── Numerical_Flux.f90          # Numerical flux dispatcher
    │   ├── Physical_Flux.f90           # Physical G13 flux F(U)
    │   ├── Rusanov_Scheme.f90          # LLF/Rusanov flux computation
    │   ├── Source_Integral.f90         # Source/production term integral
    │   └── Updating_Equations.f90      # Updates DOFs after each RK stage
    ├── RESULT_FLOW/                    # Output: flow field .plt files
    ├── RESULT_TIME/                    # Output: time history .plt files
    ├── Result_Hyperbolicity/           # Output: hyperbolicity data .plt files
    └── TIME/                           # Output: CPU timing .txt files
```

---

## Requirements

- **Fortran compiler**: `gfortran` (version 6.0 or later recommended)
- **Make**: GNU Make
- **Visualization**: [Tecplot](https://www.tecplot.com/) or any tool that reads Tecplot ASCII `.plt` format (e.g., ParaView with the Tecplot reader)

---

## How to Run

### 1. Clone the repository

```bash
git clone https://github.com/Satyvir-Singh/Satya_G13_DG_Code.git
cd Satya_G13_DG_Code/gfortran
```

### 2. Create output directories (first run only)

```bash
mkdir -p RESULT_FLOW RESULT_TIME Result_Hyperbolicity TIME
```

### 3. Configure the simulation

Edit `Input/INPUT_FILE.txt` to set your simulation parameters:

| Parameter | Description |
|-----------|-------------|
| `NELEM_X` | Number of elements in x-direction |
| `X_MIN`, `X_MAX` | Domain boundaries |
| `GOV_EQUATION_SWITCH` | Equation system selector |
| `PROBLEM_SWITCH` | Riemann problem selector (1, 2, or 3) |
| `DG_ORDER` | Polynomial degree ℓ (e.g., 1=P1, 4=P4) |
| `MAX_VPOINTS` | Number of quadrature (volume) points |
| `CFL_NUMBER` | CFL stability parameter (typical: 0.1–0.3) |
| `FINAL_TIME` | End time of the simulation |
| `NPRINT` | Output frequency (every N iterations) |
| `TEMPORAL_SCHEME_SWITCH` | Time integrator choice |
| `INVISCID_FLUX_SWITCH` | Numerical flux choice (Rusanov/LLF) |
| `POSITIVE_LIMITER_SWITCH` | Enable/disable positivity limiter (0=off, 1=on) |
| `GAMMA` | Ratio of specific heats (5/3 for monatomic ideal gas) |
| `GASR` | Specific gas constant |
| `PRODUCTION_B` | Relaxation parameter related to Knudsen number |

### 4. Build

```bash
make
```

This compiles all `.f90` sources and links the executable `dg_code`.

### 5. Run

```bash
./dg_code
```

The solver prints progress to stdout and writes output files to:
- `RESULT_FLOW/` — spatial profiles of ρ, u, p, σ, q at each output time
- `RESULT_TIME/` — time history data
- `Result_Hyperbolicity/` — (σ̄, q̄) phase-space trajectory relative to the hyperbolicity boundary
- `TIME/` — CPU timing information

### 6. Clean build artifacts

```bash
make clean
```

---

## Test Cases

Three 1D Riemann problems are provided (selected via `PROBLEM_SWITCH` in the input file), reproducing the results of the companion paper:

| Switch | Test Case | Initial Conditions | Key Feature |
|--------|-----------|-------------------|-------------|
| 1 | Shock tube | p₁/p₀ = ρ₁/ρ₀ = 5 | Sub-shocks at high Kn; loss of hyperbolicity at p₁/p₀ ≥ 15 |
| 2 | Two shock waves | Symmetric counter-propagating | Non-equilibrium in (σ,q) phase space |
| 3 | Two rarefaction waves | Asymmetric initial data | Asymmetric non-equilibrium profiles |

---

## Citation

If you use this code in your research, please cite:

```bibtex
@article{Singh2024G13DG,
  author    = {Satyvir Singh and Hang Song and Manuel Torrilhon},
  title     = {Modal Discontinuous Galerkin Simulations for {Grad}'s 13 Moment Equations:
               Application to {Riemann} Problems in the Continuum-Rarefied Flow Regime},
  journal   = {Journal of Computational and Theoretical Transport},
  volume    = {53},
  number    = {6},
  pages     = {398--422},
  year      = {2024},
  doi       = {10.1080/23324309.2024.2342947}
}
```

---

## License

Please contact the author for licensing information.

---

## Contact

**Satyvir Singh**  
Applied and Computational Mathematics (ACOM)  
RWTH Aachen University, Germany  
GitHub: [@Satyvir-Singh](https://github.com/Satyvir-Singh)
