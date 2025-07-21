# PLA Material Properties for 3D Printing

**Material:** Polylactic Acid (PLA) - Commonly used for FDM 3D printing.

**General Properties (Typical Values for FDM Printed PLA):**
* **Density:** ~1.24 g/cm³
* **Tensile Strength (Ultimate):** ~40-60 MPa (XYZ direction, good layer adhesion)
* **Yield Strength (Tensile):** ~30-50 MPa (XYZ direction)
* **Young's Modulus (Stiffness):** ~2.5-3.5 GPa
* **Elongation at Break:** ~2-6% (Brittle)

**Critical Anisotropic Properties (FDM Specific):**
* **Inter-layer Adhesion Strength (Z-axis tensile strength):** This is the weakest link. Typically 30-70% of the in-plane (XY) tensile strength, often **~15-30 MPa**. This is crucial for gear teeth and any features loaded perpendicular to print layers.
* **Shear Strength:** Typically ~60-70% of tensile strength.
* **Glass Transition Temperature (Tg):** ~50-60 °C (Important for avoiding creep or deformation under load in warmer environments).
* **Melting Temperature:** ~170-180 °C

**Implications for Design:**
* PLA is reasonably strong but brittle. Avoid sudden impacts.
* **Anisotropy is the main challenge.** Design must account for weaker layer adhesion.
* Avoid high temperatures.