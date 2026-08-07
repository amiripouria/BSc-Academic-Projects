# Electrostatic Field & Potential Simulation of an Electric Dipole

Numerical analysis, spatial vector mapping, and 3D potential visualization of a 2D electrostatic dipole using MATLAB and Coulomb's Law.

---

## 📌 Project Overview
This project models the spatial distribution of the electric field $\mathbf{E}(x,y)$ and electrostatic potential $V(x,y)$ created by a pair of equal and opposite point charges ($\pm 1\text{ nC}$) separated spatially in free space.

Key highlights:
- Application of the **Principle of Superposition** for continuous 2D grid coordinates.
- Normalization of electric field vectors to illustrate flux direction lines without spatial distortion near point singularities.
- 3D surface mapping of potential wells and peaks ($V_1 + V_2$).

---

## 📂 Deliverables
- **MATLAB Script:** [`electric_dipole_simulation.m`](./electric_dipole_simulation.m)
- **Technical LaTeX Report:** [`electric_dipole_report.pdf`](./electric_dipole_report.pdf)

---

## 📊 Visualizations

| Normalized Vector Field | E-Field Strength Contour | 3D Potential Surface |
|---|---|---|
| ![E-Field Vectors](./assets/Electric_Field.png) | ![E-Field Contour](./assets/E_Field_Strength_Contour.png) | ![3D Potential Surface](./assets/Electric_Potential_Surface.jpg) |

---

## 🛠️ Built With
- **Language:** MATLAB R2022b
- **Documentation:** LaTeX (`fancyhdr`, `amsmath`, `listings`)
