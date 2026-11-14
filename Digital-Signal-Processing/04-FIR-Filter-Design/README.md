# Digital Signal Processing - FIR Filter Design

**Author:** Pouria Amiri

This repository contains the MATLAB simulations, source code, and technical report for Laboratory 6 of the Digital Signal Processing (DSP) course. The project focuses on designing and analyzing Finite Impulse Response (FIR) filters using various windowing techniques.

## Topics Covered
1. **Filter Order Estimation:** Utilizing `kaiserord` to calculate the minimum filter order required for specific passband and stopband tolerances.
2. **FIR Filter Design:** Implementing lowpass FIR filters using the `fir1` function.
3. **Windowing Techniques:** Comparing the frequency responses, transition bands, and stopband attenuations of Kaiser, Hanning, and Blackman windows.
4. **Ripple and Attenuation Analysis:** Algorithmically validating filter performance against design constraints.

## Repository Structure
- `/src` : Contains the MATLAB script (`fir_design.m`).
- `/report` : Contains the LaTeX source code (`report.tex`) for the formal academic report.
- `/images` : High-resolution exports of the MATLAB frequency response plots.

## How to Run
1. Open MATLAB and navigate to the `/src` directory.
2. Run the `fir_design.m` script. 
3. The script will output filter parameters to the command window and generate three distinct frequency response plots for the different windowing techniques.
