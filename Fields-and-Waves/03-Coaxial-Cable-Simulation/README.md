# RG-187A/U Coaxial Cable Simulation

Analytical distribution modeling and 3D full-wave electromagnetic simulation of a standard RG-187A/U coaxial cable operating at 1 GHz.

---

## 📌 Project Overview
This project explores the fundamental transmission line characteristics of a high-frequency coaxial waveguide. The study calculates distributed per-unit-length parameters mathematically and verifies them through numerical simulation.

Key analytical phases:
- **Distributed Parameters:** Theoretical calculation of $R, L, C,$ and $G$ incorporating the skin effect at 1 GHz.
- **Transmission Properties:** Evaluation of the characteristic impedance ($Z_0 = 66.18\ \Omega$) and complex propagation constant ($\gamma$).
- **Numerical Validation:** 3D full-wave simulation using **CST Studio Suite**.
- **Reverse Extraction:** Deriving effective inductance ($L = 1.67 \times 10^{-7}\ \text{H/m}$) and capacitance ($C = 3.49 \times 10^{-11}\ \text{F/m}$) directly from the CST port parameters ($Z_0$ and $\beta$).

---

## 📂 Deliverables
- **MATLAB Code:** [`coaxial_parameters.m`](./src/coaxial_parameters.m) - Solves the analytical 1D transmission line equations.
- **CST Simulation Data:** [`cst_simulation`](./cst_simulation/) - 3D waveguide model.
- **Technical Report:** [`coaxial_report.pdf`](./docs/coaxial_report.pdf) - LaTeX document containing the reverse-calculation methodology and comparative analysis.

---

## 🛠️ Built With
- **Computational Engine:** MATLAB R2022b
- **Electromagnetic Solver:** CST Studio Suite (Waveguide Port / Time Domain Solver)
- **Documentation:** LaTeX
