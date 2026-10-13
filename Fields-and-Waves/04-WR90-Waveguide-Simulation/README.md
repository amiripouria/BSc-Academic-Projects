# WR-90 Rectangular Waveguide Modal Analysis

Analytical modeling and 3D full-wave electromagnetic simulation of a standard X-band WR-90 rectangular waveguide operating at 15 GHz.

---

## 📌 Project Overview
This project focuses on calculating the fundamental characteristics of electromagnetic wave propagation inside a rectangular boundary. The analysis evaluates multiple transverse electric (TE) modes to identify cutoff limits, phase behavior, and wave impedances.

Key analytical phases:
- **Modal Analysis:** Theoretical calculation of the cutoff frequencies ($f_c$), phase constants ($\beta$), and wave impedances ($Z_{TE}, Z_{TM}$) for the first five waveguide modes using Maxwell’s boundary value equations.
- **Dominant Mode Identification:** Mathematical validation that the $\text{TE}_{10}$ mode ($f_c \approx 6.56\text{ GHz}$) acts as the dominant mode.
- **Numerical Validation:** 3D full-wave simulation of the waveguide using **CST Studio Suite** to extract port parameters and visualize E/H field distributions.

---

## 📂 Deliverables
- **MATLAB Code:** [`wr90_analysis.m`](./src/wr90_analysis.m) - Solves the analytical dispersion equations and categorizes propagating vs. evanescent modes.
- **CST Simulation Data:** [`cst_simulation`](./cst_simulation/) - 3D waveguide model and field monitors.
- **Technical Report:** [`wr90_report.pdf`](./docs/wr90_report.pdf) - LaTeX document comparing theoretical tables with CST extraction data.

---

## 🛠️ Built With
- **Computational Engine:** MATLAB R2022b
- **Electromagnetic Solver:** CST Studio Suite (Waveguide Port Solver)
- **Documentation:** LaTeX
